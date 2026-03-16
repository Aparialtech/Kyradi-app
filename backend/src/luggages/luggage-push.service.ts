import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as admin from 'firebase-admin';
import { User } from '../users/schemas/user.schema';

type LuggagePushEvent = 'created' | 'dropped' | 'picked' | 'cancelled';

@Injectable()
export class LuggagePushService {
  private readonly logger = new Logger(LuggagePushService.name);

  constructor(@InjectModel(User.name) private readonly userModel: Model<User>) {}

  private isEnabled() {
    const raw = (process.env.PUSH_NOTIFICATIONS_ENABLED ?? 'false')
      .toString()
      .trim()
      .toLowerCase();
    return raw === '1' || raw === 'true' || raw === 'yes' || raw === 'on';
  }

  private getFirebaseApp() {
    const raw = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
    if (!raw) return null;
    if (admin.apps.length > 0) {
      return admin.app();
    }
    try {
      const creds = JSON.parse(raw);
      return admin.initializeApp({
        credential: admin.credential.cert(creds),
      });
    } catch (e) {
      this.logger.warn(`FIREBASE_PUSH_INIT_FAIL ${(e as Error)?.message ?? e}`);
      return null;
    }
  }

  private buildMessage(
    event: LuggagePushEvent,
    luggageLabel: string,
    locationName?: string,
  ) {
    const location = locationName?.trim() || 'lokasyon';
    switch (event) {
      case 'created':
        return {
          title: 'Rezervasyon alındı',
          body: `${luggageLabel} için rezervasyonun başarıyla oluşturuldu.`,
        };
      case 'dropped':
        return {
          title: 'Bavul teslim edildi',
          body: `${luggageLabel} bavulun ${location} noktasında teslim edildi.`,
        };
      case 'picked':
        return {
          title: 'Bavul teslim alındı',
          body: `${luggageLabel} bavulun başarıyla teslim alındı.`,
        };
      case 'cancelled':
        return {
          title: 'Rezervasyon iptal edildi',
          body: `${luggageLabel} için rezervasyonun iptal edildi.`,
        };
      default:
        return {
          title: 'Rezervasyon güncellendi',
          body: `${luggageLabel} için yeni bir güncelleme var.`,
        };
    }
  }

  async notifyLuggageEvent(
    userId: string,
    event: LuggagePushEvent,
    options: {
      luggageId: string;
      luggageLabel: string;
      locationName?: string;
      status?: string;
    },
  ) {
    if (!this.isEnabled()) return;
    const app = this.getFirebaseApp();
    if (!app) return;
    const user = await this.userModel.findById(userId).lean().exec();
    if (!user) return;
    if (user.pushReminderEnabled === false) return;
    const devices = Array.isArray((user as any).pushDevices)
      ? ((user as any).pushDevices as Array<any>)
      : [];
    const tokens = [
      ...new Set(
        devices
          .filter((device) => device?.enabled !== false)
          .map((device) => (device?.token ?? '').toString().trim())
          .filter((token) => token.length > 0),
      ),
    ];
    if (tokens.length === 0) return;

    const text = this.buildMessage(
      event,
      options.luggageLabel || 'Rezervasyon',
      options.locationName,
    );
    try {
      const response = await admin.messaging(app).sendEachForMulticast({
        tokens,
        notification: {
          title: text.title,
          body: text.body,
        },
        data: {
          type: `luggage_${event}`,
          luggageId: options.luggageId,
          status: options.status ?? '',
        },
        android: {
          priority: 'high',
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
            },
          },
        },
      });

      const invalidTokens: string[] = [];
      response.responses.forEach((result, index) => {
        if (!result.success) {
          const code = result.error?.code ?? '';
          if (
            code === 'messaging/registration-token-not-registered' ||
            code === 'messaging/invalid-registration-token'
          ) {
            const token = tokens[index];
            if (token) invalidTokens.push(token);
          }
        }
      });

      if (invalidTokens.length > 0) {
        await this.userModel
          .updateOne(
            { _id: userId },
            {
              $pull: {
                pushDevices: {
                  token: { $in: invalidTokens },
                },
              },
            },
          )
          .exec();
      }
    } catch (e) {
      this.logger.warn(
        `PUSH_SEND_FAIL user=${userId} luggage=${options.luggageId} err=${(e as Error)?.message ?? e}`,
      );
    }
  }
}
