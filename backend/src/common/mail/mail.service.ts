import { Injectable, Logger } from '@nestjs/common';
import * as nodemailer from 'nodemailer';
import { Transporter } from 'nodemailer';

@Injectable()
export class MailService {
  private transporter?: Transporter;
  private readonly logger = new Logger(MailService.name);

  private get provider(): 'resend' | 'smtp' {
    const raw = (process.env.MAIL_PROVIDER ?? 'resend').toLowerCase();
    return raw === 'smtp' ? 'smtp' : 'resend';
  }

  private get transportConfig() {
    if (this.provider !== 'smtp') return null;
    const host = process.env.MAIL_HOST;
    const port = Number(process.env.MAIL_PORT ?? 465);
    const secure = (process.env.MAIL_SECURE ?? 'true').toLowerCase() === 'true';
    const user = process.env.MAIL_USER;
    const pass = process.env.MAIL_PASS;

    if (!host || !user || !pass) {
      this.logger.warn(
        'SMTP mail configuration missing. Please set MAIL_HOST, MAIL_USER and MAIL_PASS.',
      );
      return null;
    }

    return {
      host,
      port,
      secure,
      auth: { user, pass },
    } as const;
  }

  private async getTransporter(): Promise<Transporter | null> {
    if (this.provider !== 'smtp') return null;
    if (this.transporter) return this.transporter;
    const config = this.transportConfig;
    if (!config) return null;

    this.transporter = nodemailer.createTransport(config);
    return this.transporter;
  }

  private fromAddress() {
    return process.env.MAIL_FROM ?? process.env.MAIL_USER ?? 'no-reply@kyradi.com';
  }

  private logProviderContext() {
    this.logger.log(`[MailService] provider=${this.provider}`);
    this.logger.log(
      `[MailService] resendKey ${process.env.RESEND_API_KEY ? 'set' : 'missing'}`,
    );
    this.logger.log(
      `[MailService] from ${process.env.MAIL_FROM ? 'set' : 'missing'}`,
    );
  }

  private async sendResendEmail(params: {
    to: string;
    subject: string;
    text: string;
    html: string;
  }): Promise<boolean> {
    const apiKey = process.env.RESEND_API_KEY;
    const from = process.env.MAIL_FROM;
    if (!apiKey || !from) {
      this.logger.warn(
        'Resend configuration missing. Please set RESEND_API_KEY and MAIL_FROM.',
      );
      return false;
    }

    try {
      const res = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${apiKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          from,
          to: params.to,
          subject: params.subject,
          html: params.html,
          text: params.text,
        }),
      });
      if (!res.ok) {
        const body = await res.text();
        this.logger.error(`[MailService] resend failed: ${res.status} ${body}`);
        return false;
      }
      this.logger.log('[MailService] resend sent ok');
      return true;
    } catch (error) {
      this.logger.error('[MailService] resend failed', (error as Error).message);
      return false;
    }
  }

  async sendResetCode(email: string, code: string): Promise<boolean> {
    const transporter = await this.getTransporter();
    if (!transporter) return false;

    try {
      await transporter.sendMail({
        from: this.fromAddress(),
        to: email,
        subject: 'KYRADI Şifre Sıfırlama Kodu',
        text: `KYRADI hesabın için şifre sıfırlama kodun: ${code}`,
        html: `<p>Merhaba,</p><p>KYRADI hesabın için şifre sıfırlama talebinde bulundun. Tek kullanımlık kodun:</p><p style="font-size:20px;font-weight:bold;letter-spacing:4px;">${code}</p><p>Bu kod 15 dakika boyunca geçerlidir. Eğer bu isteği sen yapmadıysan lütfen destek ekibimizle iletişime geç.</p>`
      });
      return true;
    } catch (error) {
      this.logger.error('Şifre sıfırlama e-postası gönderilemedi', (error as Error).message);
      return false;
    }
  }

  async sendVerificationCode(email: string, code: string): Promise<boolean> {
    const transporter = await this.getTransporter();
    if (!transporter) return false;

    try {
      await transporter.sendMail({
        from: this.fromAddress(),
        to: email,
        subject: 'KYRADI Hesap Doğrulama Kodu',
        text: `KYRADI hesabını doğrulamak için kodun: ${code}`,
        html:
            `<p>Merhaba,</p><p>KYRADI hesabını tamamlamak için aşağıdaki doğrulama kodunu kullan:</p>` +
            `<p style="font-size:22px;font-weight:bold;letter-spacing:6px;">${code}</p>` +
            '<p>Bu kod 15 dakika geçerlidir. Sen talep etmediysen bu maili yok sayabilirsin.</p>',
      });
      return true;
    } catch (error) {
      this.logger.error('Doğrulama e-postası gönderilemedi', (error as Error).message);
      return false;
    }
  }

  async sendPickupPin(params: {
    to: string;
    pin: string;
    luggageId?: string;
  }): Promise<boolean> {
    const labelLine = params.luggageId ? `Luggage ID: ${params.luggageId}\n` : '';
    const subject = 'Your Kyradi Pickup PIN';
    const text = `Your Kyradi pickup PIN:\n${labelLine}${params.pin}`;
    const html =
      `<p>Hello,</p>` +
      `<p>Your Kyradi pickup PIN:</p>` +
      (params.luggageId ? `<p><strong>Luggage ID:</strong> ${params.luggageId}</p>` : '') +
      `<p style="font-size:22px;font-weight:bold;letter-spacing:4px;">${params.pin}</p>` +
      `<p>This PIN is required for pickup.</p>`;

    this.logProviderContext();
    if (this.provider === 'resend') {
      return this.sendResendEmail({
        to: params.to,
        subject,
        text,
        html,
      });
    }

    const transporter = await this.getTransporter();
    if (!transporter) return false;
    try {
      await transporter.sendMail({
        from: this.fromAddress(),
        to: params.to,
        subject,
        text,
        html,
      });
      return true;
    } catch (error) {
      this.logger.error('Teslim PIN e-postası gönderilemedi', (error as Error).message);
      return false;
    }
  }
}
