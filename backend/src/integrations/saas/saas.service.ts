import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Luggage, LuggageStatus } from '../luggages/schemas/luggage.schema';
import { User } from '../users/schemas/user.schema';
import { Location } from '../locations/schemas/location.schema';
import { SaasClient } from './saas.client';
import { SaasReservationPayload, SaasStatusUpdate } from './saas.types';

@Injectable()
export class SaasIntegrationService {
  private readonly logger = new Logger(SaasIntegrationService.name);

  constructor(
    @InjectModel(Luggage.name)
    private readonly luggageModel: Model<Luggage>,
    @InjectModel(User.name)
    private readonly userModel: Model<User>,
    @InjectModel(Location.name)
    private readonly locationModel: Model<Location>,
    private readonly saasClient: SaasClient,
  ) {}

  async notifyReservationPaid(reservationId: string) {
    if (!this.saasClient.isEnabled()) {
      return { ok: false, reason: 'SAAS_DISABLED' };
    }
    if (!reservationId) return { ok: false, reason: 'RESERVATION_ID_MISSING' };

    const luggage = await this.luggageModel.findById(reservationId).lean().exec();
    if (!luggage) return { ok: false, reason: 'RESERVATION_NOT_FOUND' };

    if (luggage.integration?.saasNotified) {
      return { ok: true, skipped: true };
    }

    const user = await this.userModel.findById(luggage.userId).lean().exec();
    const location = luggage.dropLocationId
      ? await this.locationModel.findById(luggage.dropLocationId).lean().exec()
      : null;

    const payload: SaasReservationPayload = {
      reservationId: luggage._id?.toString() ?? reservationId,
      user: {
        id: luggage.userId ?? '',
        name: user?.name ?? undefined,
        surname: user?.surname ?? undefined,
        email: user?.email ?? undefined,
        phone: user?.phone ?? undefined,
      },
      luggage: {
        count: (luggage as any)?.count ?? undefined,
        size: luggage.size ?? undefined,
        notes: luggage.note ?? undefined,
      },
      location: {
        id: luggage.dropLocationId ?? undefined,
        name: luggage.dropLocationName ?? location?.name ?? undefined,
        city: (location as any)?.city ?? undefined,
        lat: (location as any)?.latitude ?? undefined,
        lng: (location as any)?.longitude ?? undefined,
      },
      dropAt: luggage.scheduledDropTime ? new Date(luggage.scheduledDropTime).toISOString() : null,
      pickupAt: luggage.scheduledPickupTime
        ? new Date(luggage.scheduledPickupTime).toISOString()
        : null,
      pricing: {
        base: (luggage as any)?.basePrice ?? undefined,
        insurance: (luggage as any)?.insuranceFee ?? undefined,
        hotelPayFee: (luggage as any)?.hotelPayFee ?? undefined,
        total: luggage.totalPrice ?? undefined,
        currency: 'TRY',
      },
      paid: true,
    };

    const res = await this.saasClient.postReservation(payload);
    if (res.ok) {
      await this.luggageModel.updateOne(
        { _id: luggage._id },
        {
          $set: {
            'integration.saasNotified': true,
            'integration.notifiedAt': new Date(),
            'integration.lastError': null,
            'integration.retryCount': 0,
          },
        },
      );
      return { ok: true };
    }

    await this.luggageModel.updateOne(
      { _id: luggage._id },
      {
        $set: {
          'integration.saasNotified': false,
          'integration.lastError': res.error?.toString().slice(0, 200) ?? 'SAAS_NOTIFY_FAILED',
        },
        $inc: { 'integration.retryCount': 1 },
      },
    );
    this.logger.warn(`[SAAS_NOTIFY_FAIL] reservationId=${reservationId}`);
    return { ok: false, error: res.error };
  }

  async applyStatusUpdate(body: SaasStatusUpdate) {
    const reservationId = body?.reservationId?.toString().trim();
    if (!reservationId) {
      return { ok: false, message: 'RESERVATION_ID_REQUIRED' };
    }
    const luggage = await this.luggageModel.findById(reservationId).exec();
    if (!luggage) {
      return { ok: false, message: 'RESERVATION_NOT_FOUND' };
    }

    const mapStatus = (status: SaasStatusUpdate['status']): LuggageStatus => {
      switch (status) {
        case 'assigned':
          return LuggageStatus.AWAITING;
        case 'dropped':
          return LuggageStatus.DROPPED;
        case 'picked_up':
          return LuggageStatus.PICKED;
        case 'cancelled':
        case 'rejected':
          return LuggageStatus.CANCELLED;
        default:
          return LuggageStatus.AWAITING;
      }
    };

    const nextStatus = mapStatus(body.status);
    luggage.status = nextStatus;
    if (body.storageUnit) {
      (luggage as any).storageUnit = body.storageUnit;
    }
    const now = new Date();
    if (nextStatus === LuggageStatus.DROPPED && !luggage.dropConfirmedAt) {
      luggage.dropConfirmedAt = now;
    }
    if (nextStatus === LuggageStatus.PICKED && !luggage.pickupConfirmedAt) {
      luggage.pickupConfirmedAt = now;
    }
    await luggage.save();

    return { ok: true, status: luggage.status, storageUnit: (luggage as any).storageUnit };
  }
}
