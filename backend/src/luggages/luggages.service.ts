import { HttpException, Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Luggage, LuggageStatus, PaymentStatus } from './schemas/luggage.schema';
import { CreateLuggageDto } from './dto/create-luggage.dto';
import { UpdateLuggageDto } from './dto/update-luggage.dto';
import { PricingEstimateDto } from './dto/pricing-estimate.dto';
import { Location } from '../locations/schemas/location.schema';
import { User } from '../users/schemas/user.schema';
import { MailService } from '../common/mail/mail.service';
import { hashPassword, verifyPassword } from '../common/utils/password.util';

@Injectable()
export class LuggagesService {
  private readonly logger = new Logger(LuggagesService.name);

  constructor(
    @InjectModel(Luggage.name)
    private readonly luggageModel: Model<Luggage>,
    @InjectModel(Location.name)
    private readonly locationModel: Model<Location>,
    @InjectModel(User.name)
    private readonly userModel: Model<User>,
    private readonly mailService: MailService,
  ) {}

  estimatePricing(dto: PricingEstimateDto) {
    const dropAt = new Date(dto.dropAt);
    const pickupAt = new Date(dto.pickupAt);
    if (Number.isNaN(dropAt.getTime()) || Number.isNaN(pickupAt.getTime())) {
      throw new BadRequestException('INVALID_DATE');
    }
    if (pickupAt.getTime() <= dropAt.getTime()) {
      throw new BadRequestException('PICKUP_BEFORE_DROP');
    }

    const hours = (pickupAt.getTime() - dropAt.getTime()) / (1000 * 60 * 60);
    let tier: '0-6' | '6-24' | 'daily';
    let days = 1;
    if (hours <= 6) {
      tier = '0-6';
    } else if (hours <= 24) {
      tier = '6-24';
    } else {
      tier = 'daily';
      days = Math.ceil(hours / 24);
    }

    const baseBySize: Record<PricingEstimateDto['sizeClass'], number> = {
      small: 100,
      medium: 150,
      large: 200,
    };
    const sizeBase = baseBySize[dto.sizeClass];
    if (!sizeBase) {
      throw new BadRequestException('INVALID_SIZE_CLASS');
    }

    let basePrice = sizeBase;
    if (tier === '6-24') {
      basePrice = Math.round(sizeBase * 1.5);
    } else if (tier === 'daily') {
      basePrice = days * sizeBase;
    }

    const premiumProtectionFee =
      dto.protectionLevel === 'premium' ? Math.round(basePrice * 0.2) : 0;

    const pricingSubtotal = basePrice + premiumProtectionFee;
    const hotelCommissionFee =
      dto.paymentMethod === 'pay_at_hotel' ? Math.round(pricingSubtotal * 0.1) : 0;
    const installmentFee =
      dto.paymentMethod === 'installment' ? Math.round(pricingSubtotal * 0.05) : 0;

    const total = basePrice + premiumProtectionFee + hotelCommissionFee + installmentFee;

    return {
      currency: 'TRY',
      pricingBand: tier,
      breakdown: {
        basePrice,
        premiumProtectionFee,
        hotelCommissionFee,
        installmentFee,
      },
      total,
    };
  }

  async create(userId: string, dto: CreateLuggageDto) {
    const location = await this.locationModel
      .findById(dto.dropLocationId)
      .lean()
      .exec();
    if (!location) {
      throw new NotFoundException('LOCATION_NOT_FOUND');
    }
    if (location.isActive === false) {
      throw new BadRequestException('LOCATION_INACTIVE');
    }
    let dropTime =
      dto.scheduledDropTime instanceof Date
        ? dto.scheduledDropTime
        : dto.scheduledDropTime
          ? new Date(dto.scheduledDropTime)
          : new Date();
    if (Number.isNaN(dropTime.getTime())) {
      dropTime = new Date();
    }
    const timezone = location.timezone || 'Europe/Istanbul';
    const openingHours = location.openingHours ?? {};
    if (!this._isLocationOpen(openingHours, timezone, dropTime)) {
      throw new BadRequestException('LOCATION_CLOSED');
    }
    const maxCapacity =
      typeof location.maxCapacity === 'number'
        ? location.maxCapacity
        : typeof location.totalSlots === 'number'
          ? location.totalSlots
          : 50;
    const currentOccupancy = await this._getLocationOccupancy(
      location._id?.toString() ?? location.id,
    );
    if (maxCapacity > 0 && currentOccupancy >= maxCapacity) {
      throw new BadRequestException('LOCATION_FULL');
    }

    const qrCode = await this.ensureUniqueQrCode(dto.qrCode);
    const pickupPin = this.generatePickupPin();
    const pickupPinHash = hashPassword(pickupPin);
    const created = await this.luggageModel.create({
      userId,
      ...dto,
      qrCode,
      pickupPinHash,
      scheduledDropTime: dto.scheduledDropTime ? new Date(dto.scheduledDropTime) : undefined,
      scheduledPickupTime: dto.scheduledPickupTime ? new Date(dto.scheduledPickupTime) : undefined,
    });
    await this.refreshLocationOccupancy(created.dropLocationId);
    let pinSent = false;
    let pinSentTo = '';
    const user = await this.userModel.findById(userId).lean().exec();
    if (user?.email) {
      pinSentTo = user.email;
      try {
        console.log('[PIN_MAIL] about to send', {
          to: user.email,
          luggageId: created._id?.toString(),
        });
        pinSent = await this.mailService.sendPickupPin({
          to: user.email,
          pin: pickupPin,
          luggageId: created._id?.toString(),
        });
        if (pinSent) {
          console.log('[PIN_MAIL] sent ok', {
            to: user.email,
            luggageId: created._id?.toString(),
          });
        }
      } catch (err) {
        console.error('[PIN_MAIL] send failed', err);
      }
    }
    return {
      luggage: this._decorateLuggage(created.toObject()),
      pinSent,
      pinSentTo,
    };
  }

  findByUser(userId: string) {
    return this.luggageModel
      .find({ userId })
      .sort({ createdAt: -1 })
      .lean()
      .exec()
      .then((items) => items.map((item) => this._decorateLuggage(item)));
  }

  async updateMetadata(userId: string, luggageId: string, dto: UpdateLuggageDto) {
    let delegateCode: string | undefined;
    const existing = await this.luggageModel.findOne({ _id: luggageId, userId }).exec();
    if (!existing) throw new NotFoundException('Luggage not found');
    const shouldIssueDelegate =
      (dto.pickupDelegateFullName ?? '').trim().length > 0 ||
      (dto.pickupDelegatePhone ?? '').trim().length > 0 ||
      (dto.pickupDelegateEmail ?? '').trim().length > 0;
    if (shouldIssueDelegate && !existing.delegateCodeHash) {
      delegateCode = this.generateDelegateCode();
    }
    const updated = await this.luggageModel
      .findOneAndUpdate(
        { _id: luggageId, userId },
        {
          $set: {
            ...(dto.label && { label: dto.label }),
            ...(dto.size && { size: dto.size }),
            ...(dto.weight && { weight: dto.weight }),
            ...(dto.color && { color: dto.color }),
            ...(dto.note && { note: dto.note }),
            ...(dto.dropLocationId && { dropLocationId: dto.dropLocationId }),
            ...(dto.dropLocationName && { dropLocationName: dto.dropLocationName }),
            ...(dto.scheduledDropTime && { scheduledDropTime: new Date(dto.scheduledDropTime) }),
            ...(dto.scheduledPickupTime && { scheduledPickupTime: new Date(dto.scheduledPickupTime) }),
            ...(shouldIssueDelegate && {
              pickupDelegate: {
                fullName: dto.pickupDelegateFullName?.trim() ?? '',
                phone: dto.pickupDelegatePhone?.trim() ?? '',
                email: dto.pickupDelegateEmail?.trim() ?? '',
              },
              ...(delegateCode && {
                delegateCodeHash: hashPassword(delegateCode ?? ''),
                delegateExpiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
                delegateUsedAt: null,
              }),
            }),
          },
        },
        { new: true },
      )
      .lean()
      .exec();
    if (!updated) throw new NotFoundException('Luggage not found');
    await this.refreshLocationOccupancy(updated.dropLocationId);
    return {
      luggage: this._decorateLuggage(updated),
      ...(delegateCode ? { delegateCode } : {}),
    };
  }

  async updateStatus(
    userId: string,
    luggageId: string,
    status: LuggageStatus,
    pickupPin?: string,
    delegateCode?: string,
  ) {
    try {
      const luggage = await this.luggageModel.findOne({ _id: luggageId, userId }).exec();
      if (!luggage) {
        throw new NotFoundException('Luggage not found');
      }
      const now = new Date();
      if (status === LuggageStatus.DROPPED) {
        if (luggage.paymentStatus !== PaymentStatus.PAID) {
          throw new BadRequestException('PAYMENT_REQUIRED_BEFORE_DROP');
        }
      }
      if (status === LuggageStatus.PICKED) {
        const validPin =
          !!pickupPin &&
          !!luggage.pickupPinHash &&
          verifyPassword(pickupPin, luggage.pickupPinHash);
        const hasDelegate = !!luggage.delegateCodeHash;
        const validDelegate =
          !!delegateCode &&
          !!luggage.delegateCodeHash &&
          verifyPassword(delegateCode, luggage.delegateCodeHash);
        if (!pickupPin && !delegateCode) {
          throw new BadRequestException(
            hasDelegate ? 'DELEGATE_CODE_REQUIRED' : 'PICKUP_PIN_REQUIRED',
          );
        }
        if (delegateCode) {
          if (!luggage.delegateCodeHash) {
            throw new BadRequestException('DELEGATE_CODE_INVALID');
          }
          if (luggage.delegateUsedAt) {
            throw new BadRequestException('DELEGATE_ALREADY_USED');
          }
          if (!this._isDelegateActive(luggage)) {
            throw new BadRequestException('DELEGATE_CODE_EXPIRED');
          }
          if (!validDelegate) {
            throw new BadRequestException('DELEGATE_CODE_INVALID');
          }
        } else if (pickupPin && !validPin) {
          throw new BadRequestException('PICKUP_PIN_INVALID');
        }
        if (validDelegate) {
          luggage.delegateUsedAt = now;
        }
      }
      luggage.status = status;
      if (status === LuggageStatus.DROPPED) {
        luggage.dropConfirmedAt = now;
      } else if (status === LuggageStatus.PICKED) {
        luggage.pickupConfirmedAt = now;
      }
      const saved = await luggage.save();
      await this.refreshLocationOccupancy(saved.dropLocationId?.toString());
      return this._decorateLuggage(saved.toObject());
    } catch (error) {
      this.logger.error('Luggage status update failed', (error as Error)?.stack);
      if (error instanceof HttpException) {
        throw error;
      }
      throw new HttpException('STATUS_UPDATE_FAILED', 500);
    }
  }

  private generateQrCode(): string {
    const stamp = Date.now().toString(36).toUpperCase();
    const random = Math.floor(1000 + Math.random() * 9000);
    return `BGO-${stamp}-${random}`;
  }

  private generatePickupPin(): string {
    return Math.floor(1000 + Math.random() * 9000).toString();
  }

  private generateDelegateCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  private async ensureUniqueQrCode(initial?: string): Promise<string> {
    const trimmed = initial?.trim();
    if (trimmed) {
      const exists = await this.luggageModel.exists({ qrCode: trimmed });
      if (!exists) return trimmed;
    }
    let candidate: string;
    do {
      candidate = this.generateQrCode();
    } while (await this.luggageModel.exists({ qrCode: candidate }));
    return candidate;
  }

  private async refreshLocationOccupancy(locationId?: string | null) {
    if (!locationId) return;
    const normalized = locationId.toString();
    const location = await this.locationModel.findById(normalized).lean().exec();
    if (!location) return;
    const usedSlots = await this._getLocationOccupancy(normalized);
    const capacity =
      typeof location.maxCapacity === 'number'
        ? location.maxCapacity
        : location.totalSlots ?? 0;
    const availableSlots = Math.max(capacity - usedSlots, 0);
    await this.locationModel
      .updateOne(
        { _id: normalized },
        {
          $set: {
            usedSlots,
            availableSlots,
            updatedAt: new Date(),
          },
        },
      )
      .exec();
  }

  private async _getLocationOccupancy(locationId: string) {
    return this.luggageModel
      .countDocuments({
        dropLocationId: locationId,
        status: { $in: [LuggageStatus.AWAITING, LuggageStatus.DROPPED] },
      })
      .exec();
  }

  private _isLocationOpen(
    openingHours: Record<string, { start: string; end: string }[]>,
    timezone: string,
    reference: Date,
  ) {
    if (!openingHours || Object.keys(openingHours).length === 0) return true;
    let parts: Intl.DateTimeFormatPart[];
    try {
      const formatter = new Intl.DateTimeFormat('en-US', {
        timeZone: timezone,
        weekday: 'short',
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
      });
      parts = formatter.formatToParts(reference);
    } catch {
      const fallback = new Intl.DateTimeFormat('en-US', {
        weekday: 'short',
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
      });
      parts = fallback.formatToParts(reference);
    }
    const weekdayPart = parts.find((part) => part.type === 'weekday')?.value ?? '';
    const hourPart = parts.find((part) => part.type === 'hour')?.value ?? '00';
    const minutePart = parts.find((part) => part.type === 'minute')?.value ?? '00';
    const dayKey = this._weekdayKey(weekdayPart);
    const ranges = (openingHours?.[dayKey] ?? []) as { start: string; end: string }[];
    if (ranges.length === 0) return false;
    const nowMinutes = Number(hourPart) * 60 + Number(minutePart);
    return ranges.some((range) => {
      const start = this._timeToMinutes(range.start);
      const end = this._timeToMinutes(range.end);
      if (start === null || end === null) return false;
      return nowMinutes >= start && nowMinutes <= end;
    });
  }

  private _weekdayKey(value: string) {
    const normalized = value.toLowerCase().slice(0, 3);
    switch (normalized) {
      case 'mon':
        return 'mon';
      case 'tue':
        return 'tue';
      case 'wed':
        return 'wed';
      case 'thu':
        return 'thu';
      case 'fri':
        return 'fri';
      case 'sat':
        return 'sat';
      case 'sun':
        return 'sun';
      default:
        return 'mon';
    }
  }

  private _timeToMinutes(value?: string) {
    if (!value) return null;
    const [hourRaw, minuteRaw] = value.split(':');
    const hour = Number(hourRaw);
    const minute = Number(minuteRaw);
    if (Number.isNaN(hour) || Number.isNaN(minute)) return null;
    return hour * 60 + minute;
  }

  private _isDelegateActive(luggage: Luggage) {
    if (!luggage.delegateCodeHash || !luggage.delegateExpiresAt) return false;
    if (luggage.delegateUsedAt) return false;
    const expiresAt =
      luggage.delegateExpiresAt instanceof Date
        ? luggage.delegateExpiresAt
        : new Date(luggage.delegateExpiresAt);
    return expiresAt.getTime() > Date.now();
  }

  private _decorateLuggage(luggage: any) {
    const payload = { ...luggage };
    delete payload.pickupPinHash;
    delete payload.delegateCodeHash;
    return {
      ...payload,
      delegateActive: this._isDelegateActive(luggage as Luggage),
    };
  }

}
