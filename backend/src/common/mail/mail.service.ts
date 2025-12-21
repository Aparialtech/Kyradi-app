import { Injectable, Logger } from '@nestjs/common';
import * as nodemailer from 'nodemailer';
import { Transporter } from 'nodemailer';

@Injectable()
export class MailService {
  private transporter?: Transporter;
  private readonly logger = new Logger(MailService.name);

  private get useResend() {
    return !!process.env.RESEND_API_KEY;
  }

  private get transportConfig() {
    // Resend kullanılıyorsa
    if (this.useResend) {
      return {
        host: 'smtp.resend.com',
        port: 465,
        secure: true,
        auth: {
          user: 'resend',
          pass: process.env.RESEND_API_KEY,
        },
      } as const;
    }

    // Normal SMTP
    const host = process.env.MAIL_HOST;
    const port = Number(process.env.MAIL_PORT ?? 587);
    const secure = (process.env.MAIL_SECURE ?? 'false').toLowerCase() === 'true';
    const user = process.env.MAIL_USER;
    const pass = process.env.MAIL_PASS;

    if (!host || !user || !pass) {
      this.logger.warn('Mail configuration missing. Please set RESEND_API_KEY or MAIL_HOST, MAIL_USER and MAIL_PASS.');
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
    if (this.transporter) return this.transporter;
    const config = this.transportConfig;
    if (!config) return null;

    this.transporter = nodemailer.createTransport(config);
    return this.transporter;
  }

  private fromAddress() {
    if (this.useResend) {
      return process.env.MAIL_FROM ?? 'Kyradi <onboarding@resend.dev>';
    }
    return process.env.MAIL_FROM ?? process.env.MAIL_USER ?? 'no-reply@kyradi.com';
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
}
