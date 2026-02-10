import { Injectable, Logger } from '@nestjs/common';
import { SaasReservationPayload } from './saas.types';
import { resolveBodyString, signBody, verifySignature } from './saas.sign';

type SaasPostResult =
  | { ok: true; status: number; data?: Record<string, any> }
  | { ok: false; status?: number; error: string };

@Injectable()
export class SaasClient {
  private readonly logger = new Logger(SaasClient.name);

  private get baseUrl(): string | null {
    const raw = process.env.SAAS_BASE_URL?.trim();
    return raw ? raw.replace(/\/$/, '') : null;
  }

  private get secret(): string | null {
    const raw = process.env.SAAS_INTEGRATION_SECRET?.trim();
    return raw ? raw : null;
  }

  private get timeoutMs(): number {
    const raw = Number(process.env.SAAS_TIMEOUT_MS ?? 8000);
    return Number.isFinite(raw) && raw > 0 ? raw : 8000;
  }

  private get retryCount(): number {
    const raw = Number(process.env.SAAS_RETRY_COUNT ?? 2);
    return Number.isFinite(raw) && raw >= 0 ? raw : 2;
  }

  isEnabled(): boolean {
    return !!this.baseUrl && !!this.secret;
  }

  buildSignature(bodyString: string): string | null {
    if (!this.secret) return null;
    return signBody(bodyString, this.secret);
  }

  verifyIncomingSignature(rawBody: string | undefined, body: unknown, signature?: string): boolean {
    if (!this.secret) return false;
    if (!rawBody || rawBody.length === 0) return false;
    return verifySignature(rawBody, signature, this.secret);
  }

  async postReservation(payload: SaasReservationPayload): Promise<SaasPostResult> {
    if (!this.baseUrl || !this.secret) {
      return { ok: false, error: 'SAAS_NOT_CONFIGURED' };
    }
    const url = `${this.baseUrl}/api/integrations/reservations`;
    const bodyString = JSON.stringify(payload);
    const signature = signBody(bodyString, this.secret);

    const attemptOnce = async (): Promise<SaasPostResult> => {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), this.timeoutMs);
      try {
        const res = await fetch(url, {
          method: 'POST',
          headers: {
            'content-type': 'application/json',
            'x-kyradi-signature': signature,
          },
          body: bodyString,
          signal: controller.signal,
        });
        if (res.ok) {
          let data: Record<string, any> | undefined;
          try {
            const json = await res.json();
            if (json && typeof json === 'object') data = json as Record<string, any>;
          } catch {
            data = undefined;
          }
          return { ok: true, status: res.status, data };
        }
        const text = await res.text();
        return { ok: false, status: res.status, error: text || 'SAAS_BAD_RESPONSE' };
      } catch (err) {
        const message = (err as Error)?.message || 'SAAS_REQUEST_FAILED';
        return { ok: false, error: message };
      } finally {
        clearTimeout(timeout);
      }
    };

    let last: SaasPostResult = { ok: false, error: 'SAAS_REQUEST_FAILED' };
    for (let attempt = 0; attempt <= this.retryCount; attempt += 1) {
      last = await attemptOnce();
      if (last.ok) return last;
      const retryable =
        !('status' in last) || (typeof last.status === 'number' && last.status >= 500);
      if (!retryable) break;
    }

    if (!last.ok) {
      this.logger.warn(
        `[SAAS_NOTIFY_FAIL] ${last.error}${last.status ? ` status=${last.status}` : ''}`,
      );
    }
    return last;
  }
}
