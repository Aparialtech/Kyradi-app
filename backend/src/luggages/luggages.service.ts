import { HttpException, Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Luggage, LuggageStatus } from './schemas/luggage.schema';
import { CreateLuggageDto } from './dto/create-luggage.dto';
import { UpdateLuggageDto } from './dto/update-luggage.dto';
import { Location } from '../locations/schemas/location.schema';
import { hashPassword, verifyPassword } from '../common/utils/password.util';

@Injectable()
export class LuggagesService {
  private readonly logger = new Logger(LuggagesService.name);

  constructor(
    @InjectModel(Luggage.name)
    private readonly luggageModel: Model<Luggage>,
    @InjectModel(Location.name)
    private readonly locationModel: Model<Location>,
  ) {}

  async create(userId: string, dto: CreateLuggageDto) {
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
    return {
      luggage: this._decorateLuggage(created.toObject()),
      pickupPin,
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
    const shouldIssueDelegate =
      (dto.pickupDelegateFullName ?? '').trim().length > 0 ||
      (dto.pickupDelegatePhone ?? '').trim().length > 0 ||
      (dto.pickupDelegateEmail ?? '').trim().length > 0;
    if (shouldIssueDelegate) {
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
              delegateCodeHash: hashPassword(delegateCode ?? ''),
              delegateExpiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
              delegateUsedAt: null,
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
      if (status === LuggageStatus.PICKED) {
        const validPin =
          !!pickupPin &&
          !!luggage.pickupPinHash &&
          verifyPassword(pickupPin, luggage.pickupPinHash);
        const validDelegate =
          !!delegateCode &&
          !!luggage.delegateCodeHash &&
          verifyPassword(delegateCode, luggage.delegateCodeHash);
        if (!validPin && !validDelegate) {
          if (!pickupPin && !delegateCode) {
            throw new BadRequestException('PICKUP_CREDENTIAL_REQUIRED');
          }
          if (pickupPin && !validPin) {
            throw new BadRequestException('PICKUP_PIN_INVALID');
          }
          if (delegateCode && !validDelegate) {
            throw new BadRequestException('DELEGATE_CODE_INVALID');
          }
          throw new BadRequestException('PICKUP_CREDENTIAL_INVALID');
        }
        if (validDelegate && this._isDelegateActive(luggage)) {
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
    const usedSlots = await this.luggageModel
      .countDocuments({
        dropLocationId: normalized,
        status: LuggageStatus.DROPPED,
      })
      .exec();
    const totalSlots = location.totalSlots ?? 0;
    const availableSlots = Math.max(totalSlots - usedSlots, 0);
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
