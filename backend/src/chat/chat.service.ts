import { Injectable, Logger } from '@nestjs/common';

type ChatProvider = 'openai' | 'gemini' | 'disabled';

@Injectable()
export class ChatService {
  private readonly logger = new Logger(ChatService.name);

  private get provider(): ChatProvider {
    const raw = (process.env.CHAT_PROVIDER ?? 'disabled').toLowerCase();
    if (raw === 'openai' || raw === 'gemini') return raw;
    return 'disabled';
  }

  private get apiKey(): string | null {
    return process.env.CHAT_API_KEY?.trim() || null;
  }

  private get model(): string {
    return process.env.CHAT_MODEL?.trim() || 'gpt-4o-mini';
  }

  private get timeoutMs(): number {
    const raw = Number(process.env.CHAT_TIMEOUT_MS ?? 12000);
    return Number.isFinite(raw) && raw > 0 ? raw : 12000;
  }

  health() {
    const providerReady = this.provider !== 'disabled' && !!this.apiKey;
    return {
      ok: true,
      provider: this.provider,
      providerReady,
      model: this.model,
      timeoutMs: this.timeoutMs,
      message: providerReady ? 'ready' : 'provider disabled or key missing',
    };
  }

  async sendMessage(message: string, sessionId?: string) {
    const providerReady = this.provider !== 'disabled' && !!this.apiKey;
    if (!providerReady) {
      return {
        ok: false,
        reply: null,
        sessionId: sessionId ?? null,
        error: 'CHAT_DISABLED',
        message: 'Chat geçici olarak kapalı.',
      };
    }
    const trimmed = message.trim();
    if (!trimmed) {
      return {
        ok: false,
        reply: null,
        sessionId: sessionId ?? null,
        error: 'EMPTY_MESSAGE',
        message: 'Mesaj boş olamaz.',
      };
    }

    this.logger.log(
      `CHAT_SEND provider=${this.provider} model=${this.model} len=${trimmed.length}`,
    );

    try {
      if (this.provider === 'openai') {
        return await this.sendOpenAi(trimmed, sessionId);
      }
      return await this.sendGemini(trimmed, sessionId);
    } catch (e) {
      this.logger.error(`CHAT_ERROR ${String(e)}`);
      return {
        ok: false,
        reply: null,
        sessionId: sessionId ?? null,
        error: 'CHAT_PROVIDER_ERROR',
        message: 'Chat şu anda yanıt veremiyor.',
      };
    }
  }

  private async sendOpenAi(message: string, sessionId?: string) {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), this.timeoutMs);
    const res = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: this.model,
        messages: [
          {
            role: 'system',
            content:
              'You are Kyradi virtual support. Answer briefly and helpfully in Turkish.',
          },
          { role: 'user', content: message },
        ],
        temperature: 0.4,
      }),
      signal: controller.signal,
    }).finally(() => clearTimeout(timer));

    if (!res.ok) {
      const body = await res.text();
      this.logger.error(`OPENAI_FAIL status=${res.status} body=${body}`);
      return {
        ok: false,
        reply: null,
        sessionId: sessionId ?? null,
        error: 'CHAT_PROVIDER_ERROR',
        message: 'Chat şu anda yanıt veremiyor.',
      };
    }
    const data = await res.json();
    const reply =
      data?.choices?.[0]?.message?.content?.toString()?.trim() || '';
    return {
      ok: true,
      reply,
      sessionId: sessionId ?? null,
    };
  }

  private async sendGemini(message: string, sessionId?: string) {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), this.timeoutMs);
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(
      this.model,
    )}:generateContent?key=${encodeURIComponent(this.apiKey ?? '')}`;
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: message }], role: 'user' }],
        systemInstruction: {
          parts: [{ text: 'Kyradi sanal destek olarak Türkçe cevap ver.' }],
        },
      }),
      signal: controller.signal,
    }).finally(() => clearTimeout(timer));

    if (!res.ok) {
      const body = await res.text();
      this.logger.error(`GEMINI_FAIL status=${res.status} body=${body}`);
      return {
        ok: false,
        reply: null,
        sessionId: sessionId ?? null,
        error: 'CHAT_PROVIDER_ERROR',
        message: 'Chat şu anda yanıt veremiyor.',
      };
    }
    const data = await res.json();
    const reply =
      data?.candidates?.[0]?.content?.parts?.[0]?.text?.toString()?.trim() ||
      '';
    return {
      ok: true,
      reply,
      sessionId: sessionId ?? null,
    };
  }
}
