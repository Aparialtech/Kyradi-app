import { HttpException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Luggage, LuggageStatus } from './schemas/luggage.schema';
import { CreateLuggageDto } from './dto/create-luggage.dto';
import { UpdateLuggageDto } from './dto/update-luggage.dto';
import { Location } from '../locations/schemas/location.schema';

@Injectable()
export class LuggagesService {
  constructor(
    @InjectModel(Luggage.name)
    private readonly luggageModel: Model<Luggage>,
    @InjectModel(Location.name)
    private readonly locationModel: Model<Location>,
  ) {}

  async create(userId: string, dto: CreateLuggageDto) {
    const qrCode = await this.ensureUniqueQrCode(dto.qrCode);
    return this.luggageModel.create({
      userId,
      ...dto,
      qrCode,
      scheduledDropTime: dto.scheduledDropTime ? new Date(dto.scheduledDropTime) : undefined,
      scheduledPickupTime: dto.scheduledPickupTime ? new Date(dto.scheduledPickupTime) : undefined,
    });
  }

  findByUser(userId: string) {
    return this.luggageModel
      .find({ userId })
      .sort({ createdAt: -1 })
      .lean()
      .exec();
  }

  async updateMetadata(userId: string, luggageId: string, dto: UpdateLuggageDto) {
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
          },
        },
        { new: true },
      )
      .lean()
      .exec();
    if (!updated) throw new NotFoundException('Luggage not found');
    await this.refreshLocationOccupancy(updated.dropLocationId);
    return updated;
  }

  async updateStatus(userId: string, luggageId: string, status: LuggageStatus) {
    try {
      const luggage = await this.luggageModel.findOne({ _id: luggageId, userId }).exec();
      if (!luggage) {
        throw new NotFoundException('Luggage not found');
      }
      const now = new Date();
      luggage.status = status;
      if (status === LuggageStatus.DROPPED) {
        luggage.dropConfirmedAt = now;
      } else if (status === LuggageStatus.PICKED) {
        luggage.pickupConfirmedAt = now;
      }
      const saved = await luggage.save();
      await this.refreshLocationOccupancy(saved.dropLocationId?.toString());
      return saved.toObject();
    } catch (error) {
      console.error('Luggage status update failed', error);
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
}
