import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class MailService {
  private readonly logger = new Logger(MailService.name);

  private get resendApiKey() {
    return process.env.RESEND_API_KEY;
  }

  private fromAddress() {
    return process.env.MAIL_FROM ?? 'Kyradi <onboarding@resend.dev>';
  }

  private async sendWithResend(to: string, subject: string, text: string, html: string): Promise<boolean> {
    const apiKey = this.resendApiKey;
    if (!apiKey) {
      this.logger.warn('RESEND_API_KEY is not set. Email will not be sent.');
      return false;
    }

    try {
      const response = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`,
        },
        body: JSON.stringify({
          from: this.fromAddress(),
          to: [to],
          subject,
          text,
          html,
        }),
      });

      if (!response.ok) {
        const errorData = await response.text();
        this.logger.error(`Resend API error: ${response.status} - ${errorData}`);
        return false;
      }

      const data = await response.json();
      this.logger.log(`Email sent successfully: ${data.id}`);
      return true;
    } catch (error) {
      this.logger.error('Email gönderilemedi', (error as Error).message);
      return false;
    }
  }

  async sendResetCode(email: string, code: string): Promise<boolean> {
    return this.sendWithResend(
      email,
      'KYRADI Şifre Sıfırlama Kodu',
      `KYRADI hesabın için şifre sıfırlama kodun: ${code}`,
      `<p>Merhaba,</p><p>KYRADI hesabın için şifre sıfırlama talebinde bulundun. Tek kullanımlık kodun:</p><p style="font-size:20px;font-weight:bold;letter-spacing:4px;">${code}</p><p>Bu kod 15 dakika boyunca geçerlidir. Eğer bu isteği sen yapmadıysan lütfen destek ekibimizle iletişime geç.</p>`
    );
  }

  async sendVerificationCode(email: string, code: string): Promise<boolean> {
    return this.sendWithResend(
      email,
      'KYRADI Hesap Doğrulama Kodu',
      `KYRADI hesabını doğrulamak için kodun: ${code}`,
      `<p>Merhaba,</p><p>KYRADI hesabını tamamlamak için aşağıdaki doğrulama kodunu kullan:</p><p style="font-size:22px;font-weight:bold;letter-spacing:6px;">${code}</p><p>Bu kod 15 dakika geçerlidir. Sen talep etmediysen bu maili yok sayabilirsin.</p>`
    );
  }
}
