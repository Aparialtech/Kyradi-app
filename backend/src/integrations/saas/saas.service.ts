import { BadRequestException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Luggage, LuggageStatus, PaymentStatus } from '../../luggages/schemas/luggage.schema';
import { User } from '../../users/schemas/user.schema';
import { Location } from '../../locations/schemas/location.schema';
import { SaasClient } from './saas.client';
import { SaasDiagnoseRequest, SaasReservationPayload, SaasStatusUpdate } from './saas.types';

@Injectable()
export class SaasIntegrationService {
  private readonly logger = new Logger(SaasIntegrationService.name);

  private extractExternalReservationId(note?: string): string | undefined {
    if (!note) return undefined;
    const match = note.match(/SUPERAPP_EXTERNAL_RES_ID:([A-Za-z0-9-_]+)/);
    return match?.[1];
  }

  private escapeRegex(value: string): string {
    return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

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

    const alreadyMapped =
      !!(luggage as any)?.saasReservationId || !!luggage.integration?.saasReservationId;
    // If we previously notified SaaS but never persisted mapping, retry a few times.
    // This relies on SaaS being idempotent for the same `reservationId` we send (SuperApp luggage _id).
    const mappingRetryCount = Number(luggage.integration?.retryCount ?? 0);
    const shouldRetryBecauseMappingMissing = luggage.integration?.saasNotified && !alreadyMapped;
    if (luggage.integration?.saasNotified && (!shouldRetryBecauseMappingMissing || mappingRetryCount >= 3)) {
      return { ok: true, skipped: true };
    }

    const user = await this.userModel.findById(luggage.userId).lean().exec();
    const location = luggage.dropLocationId
      ? await this.locationModel.findById(luggage.dropLocationId).lean().exec()
      : null;

    const externalReservationIdToSend =
      this.extractExternalReservationId(luggage.note) ??
      (luggage as any)?.externalReservationId ??
      luggage.integration?.externalReservationId ??
      luggage._id?.toString() ??
      reservationId;

    const payload: SaasReservationPayload = {
      reservationId: luggage._id?.toString() ?? reservationId,
      externalReservationId: externalReservationIdToSend,
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
      const data = res.data ?? {};
      const saasReservationId =
        data.saasReservationId?.toString() ??
        data.reservationId?.toString() ??
        data.id?.toString();
      const storageUnit =
        data.storageUnit?.toString() ??
        data.storage_id?.toString() ??
        data.storageId?.toString() ??
        data.storage_unit?.toString();
      try {
        await this.luggageModel.updateOne(
          { _id: luggage._id },
          {
            $set: {
              'integration.saasNotified': true,
              'integration.notifiedAt': new Date(),
              'integration.lastError': null,
              'integration.retryCount': 0,
              // Persist mapping in both integration.* (legacy) and top-level fields (indexed).
              'integration.externalReservationId': externalReservationIdToSend,
              externalReservationId: externalReservationIdToSend,
              ...(saasReservationId ? { 'integration.saasReservationId': saasReservationId } : {}),
              ...(saasReservationId ? { saasReservationId } : {}),
              ...(storageUnit ? { storageUnit } : {}),
            },
          },
        );
        this.logger.log(
          `[SAAS_MAPPING_SAVED] luggageId=${luggage._id?.toString()} hasSaasId=${!!saasReservationId} hasExternalId=${!!externalReservationIdToSend}`,
        );
      } catch (e) {
        // Never break payment flow due to integration persistence failure.
        this.logger.warn(
          `[SAAS_MAPPING_SAVE_FAIL] luggageId=${luggage._id?.toString()} err=${(e as Error)?.message ?? e}`,
        );
      }
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
    const raw: any = body as any;
    const reservationId = raw?.reservationId?.toString().trim() ?? raw?.reservation_id?.toString().trim();
    const saasReservationId =
      raw?.saasReservationId?.toString().trim() ?? raw?.saas_reservation_id?.toString().trim();
    const externalReservationIdRaw =
      raw?.externalReservationId?.toString().trim() ??
      raw?.external_reservation_id?.toString().trim() ??
      raw?.externalReservationID?.toString().trim();

    const isObjectId =
      !!reservationId &&
      Types.ObjectId.isValid(reservationId) &&
      new Types.ObjectId(reservationId).toString() === reservationId;
    // If SaaS sends only reservationId (UUID), treat it as the SaaS id.
    const saasIdCandidate = saasReservationId || (!isObjectId ? reservationId : undefined);
    // If SaaS doesn't send externalReservationId explicitly, fallback to reservationId as legacy.
    const externalReservationId =
      externalReservationIdRaw || (!isObjectId && reservationId ? reservationId : undefined);

    if (!reservationId && !saasIdCandidate && !externalReservationId) {
      throw new BadRequestException({
        message: 'reservationId_or_externalReservationId_required',
        errorCode: 'RESERVATION_ID_REQUIRED',
      });
    }
    let luggage: Luggage | null = null;
    let matchedBy: string = 'none';
    const lookupTried: string[] = [];

    if (reservationId && isObjectId) {
      lookupTried.push('id');
      luggage = await this.luggageModel.findById(reservationId).exec();
      if (luggage) matchedBy = 'id';
    }
    if (!luggage && saasIdCandidate) {
      lookupTried.push('saasReservationId');
      luggage = await this.luggageModel.findOne({
        $or: [{ saasReservationId: saasIdCandidate }, { 'integration.saasReservationId': saasIdCandidate }],
      }).exec();
      if (luggage) matchedBy = 'saasReservationId';
    }
    if (!luggage && externalReservationId) {
      lookupTried.push('externalReservationId');
      luggage = await this.luggageModel.findOne({
        $or: [
          { externalReservationId },
          { 'integration.externalReservationId': externalReservationId },
        ],
      }).exec();
      if (luggage) matchedBy = 'externalReservationId';
    }
    if (!luggage && externalReservationId) {
      lookupTried.push('noteRegex');
      const re = new RegExp(`SUPERAPP_EXTERNAL_RES_ID:\\s*${this.escapeRegex(externalReservationId)}`);
      luggage = await this.luggageModel.findOne({ note: re }).exec();
      if (luggage) matchedBy = 'noteRegex';
    }

    console.log(
      `SAAS_STATUS_UPDATE lookup: lookupBy=${matchedBy} tried=${lookupTried.join(
        ',',
      )} reservationId=${reservationId ?? ''} ` +
        `saasReservationId=${saasIdCandidate ?? ''} externalReservationId=${externalReservationId ?? ''}`,
    );

    if (!luggage) {
      throw new NotFoundException({
        message: 'RESERVATION_NOT_FOUND',
        errorCode: 'RESERVATION_NOT_FOUND',
        reservationId: reservationId ?? null,
        saasReservationId: saasIdCandidate ?? null,
        externalReservationId: externalReservationId ?? null,
        lookupBy: matchedBy,
        lookupTried,
      });
    }

    const mapStatus = (status: SaasStatusUpdate['status']): LuggageStatus => {
      switch (status) {
        case 'assigned':
          return LuggageStatus.AWAITING;
        case 'dropped':
          return LuggageStatus.DROPPED;
        case 'completed':
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
    const isPaid =
      luggage.paymentStatus === PaymentStatus.PAID ||
      !!luggage.paidAt ||
      (!!luggage.transactionId && luggage.transactionId.trim().length > 0);
    if (nextStatus === LuggageStatus.DROPPED && !isPaid) {
      return { ok: true, status: luggage.status, storageUnit: (luggage as any).storageUnit };
    }

    luggage.status = nextStatus;
    if (saasIdCandidate || externalReservationId) {
      (luggage as any).integration = {
        ...(luggage as any).integration,
        ...(saasIdCandidate ? { saasReservationId: saasIdCandidate } : {}),
        ...(externalReservationId ? { externalReservationId } : {}),
      };
    }
    if (saasIdCandidate) {
      (luggage as any).saasReservationId = saasIdCandidate;
    }
    if (externalReservationId) {
      (luggage as any).externalReservationId = externalReservationId;
    }
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

  async diagnoseStatusUpdate(body: SaasDiagnoseRequest) {
    const raw: any = body as any;
    const reservationId =
      raw?.reservationId?.toString().trim() ?? raw?.reservation_id?.toString().trim();
    const saasReservationId =
      raw?.saasReservationId?.toString().trim() ?? raw?.saas_reservation_id?.toString().trim();
    const externalReservationIdRaw =
      raw?.externalReservationId?.toString().trim() ??
      raw?.external_reservation_id?.toString().trim() ??
      raw?.externalReservationID?.toString().trim();

    const isObjectId =
      !!reservationId &&
      Types.ObjectId.isValid(reservationId) &&
      new Types.ObjectId(reservationId).toString() === reservationId;
    const saasIdCandidate = saasReservationId || (!isObjectId ? reservationId : undefined);
    const externalReservationId =
      externalReservationIdRaw || (!isObjectId && reservationId ? reservationId : undefined);

    if (!reservationId && !saasIdCandidate && !externalReservationId) {
      throw new BadRequestException({
        message: 'reservationId_or_externalReservationId_required',
        errorCode: 'RESERVATION_ID_REQUIRED',
      });
    }

    let luggage: Luggage | null = null;
    let matchedBy: string = 'none';
    const lookupTried: string[] = [];

    if (reservationId && isObjectId) {
      lookupTried.push('id');
      luggage = await this.luggageModel.findById(reservationId).exec();
      if (luggage) matchedBy = 'id';
    }
    if (!luggage && saasIdCandidate) {
      lookupTried.push('saasReservationId');
      luggage = await this.luggageModel
        .findOne({
          $or: [
            { saasReservationId: saasIdCandidate },
            { 'integration.saasReservationId': saasIdCandidate },
          ],
        })
        .exec();
      if (luggage) matchedBy = 'saasReservationId';
    }
    if (!luggage && externalReservationId) {
      lookupTried.push('externalReservationId');
      luggage = await this.luggageModel
        .findOne({
          $or: [
            { externalReservationId },
            { 'integration.externalReservationId': externalReservationId },
          ],
        })
        .exec();
      if (luggage) matchedBy = 'externalReservationId';
    }
    if (!luggage && externalReservationId) {
      lookupTried.push('noteRegex');
      const re = new RegExp(`SUPERAPP_EXTERNAL_RES_ID:\\s*${this.escapeRegex(externalReservationId)}`);
      luggage = await this.luggageModel.findOne({ note: re }).exec();
      if (luggage) matchedBy = 'noteRegex';
    }

    console.log(
      `SAAS_DIAG lookup: lookupBy=${matchedBy} tried=${lookupTried.join(
        ',',
      )} reservationId=${reservationId ?? ''} saasReservationId=${saasIdCandidate ?? ''} externalReservationId=${externalReservationId ?? ''}`,
    );

    if (!luggage) {
      throw new NotFoundException({
        message: 'RESERVATION_NOT_FOUND',
        errorCode: 'RESERVATION_NOT_FOUND',
        reservationId: reservationId ?? null,
        saasReservationId: saasIdCandidate ?? null,
        externalReservationId: externalReservationId ?? null,
        lookupBy: matchedBy,
        lookupTried,
      });
    }

    // Return minimal fields only (no PII).
    return {
      ok: true,
      lookupBy: matchedBy,
      lookupTried,
      luggage: {
        id: luggage._id?.toString() ?? null,
        status: luggage.status ?? null,
        storageUnit: (luggage as any).storageUnit ?? null,
        saasReservationId: (luggage as any).saasReservationId ?? luggage.integration?.saasReservationId ?? null,
        externalReservationId:
          (luggage as any).externalReservationId ?? luggage.integration?.externalReservationId ?? null,
        updatedAt: (luggage as any).updatedAt ?? null,
      },
    };
  }
}
