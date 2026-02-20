import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from '../users/schemas/user.schema';
import { Luggage } from '../luggages/schemas/luggage.schema';
import { Location } from '../locations/schemas/location.schema';
import { Campaign } from '../campaigns/schemas/campaign.schema';
import { UpsertLocationDto } from './dto/upsert-location.dto';
import { UpsertCampaignDto } from './dto/upsert-campaign.dto';

@Injectable()
export class AdminService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<User>,
    @InjectModel(Luggage.name) private readonly luggageModel: Model<Luggage>,
    @InjectModel(Location.name) private readonly locationModel: Model<Location>,
    @InjectModel(Campaign.name) private readonly campaignModel: Model<Campaign>,
  ) {}

  async getOverview() {
    const now = Date.now();
    const last7d = new Date(now - 7 * 24 * 60 * 60 * 1000);

    const [
      usersTotal,
      usersLast7d,
      locationsTotal,
      activeLocations,
      campaignsTotal,
      activeCampaigns,
      luggageTotal,
      paymentPending,
      statusRaw,
      recentLuggages,
    ] = await Promise.all([
      this.userModel.countDocuments().exec(),
      this.userModel.countDocuments({ createdAt: { $gte: last7d } }).exec(),
      this.locationModel.countDocuments().exec(),
      this.locationModel.countDocuments({ isActive: true }).exec(),
      this.campaignModel.countDocuments().exec(),
      this.campaignModel.countDocuments({ isActive: true }).exec(),
      this.luggageModel.countDocuments().exec(),
      this.luggageModel
        .countDocuments({ paymentStatus: { $in: ['pending', 'failed'] } })
        .exec(),
      this.luggageModel
        .aggregate<{ _id: string; total: number }>([
          { $group: { _id: '$status', total: { $sum: 1 } } },
        ])
        .exec(),
      this.luggageModel
        .find()
        .sort({ updatedAt: -1 })
        .limit(20)
        .select(
          'userId status paymentStatus dropLocationName totalPrice updatedAt createdAt',
        )
        .lean()
        .exec(),
    ]);

    const statusCounts = statusRaw.reduce<Record<string, number>>((acc, item) => {
      const key = (item?._id ?? 'unknown').toString();
      acc[key] = item.total ?? 0;
      return acc;
    }, {});

    const userIds = Array.from(
      new Set(recentLuggages.map((item) => (item.userId ?? '').toString()).filter(Boolean)),
    );
    const users = userIds.length
      ? await this.userModel
          .find({ _id: { $in: userIds } })
          .select('name surname email')
          .lean()
          .exec()
      : [];
    const userMap = new Map(
      users.map((item: any) => [
        item._id?.toString(),
        `${item.name ?? ''} ${item.surname ?? ''}`.trim() || item.email || 'Kullanici',
      ]),
    );

    const recentActivity = recentLuggages.map((item: any) => ({
      id: item._id?.toString(),
      userId: item.userId?.toString(),
      userName: userMap.get(item.userId?.toString()) ?? 'Kullanici',
      status: item.status ?? 'awaiting_drop',
      paymentStatus: item.paymentStatus ?? 'unpaid',
      dropLocationName: item.dropLocationName ?? '-',
      totalPrice: item.totalPrice ?? 0,
      updatedAt: item.updatedAt ?? item.createdAt ?? null,
    }));

    return {
      users: {
        total: usersTotal,
        last7d: usersLast7d,
      },
      locations: {
        total: locationsTotal,
        active: activeLocations,
      },
      campaigns: {
        total: campaignsTotal,
        active: activeCampaigns,
      },
      luggage: {
        total: luggageTotal,
        paymentPending,
        statusCounts,
      },
      recentActivity,
    };
  }

  async promoteSelfToAdmin(userId: string) {
    if (!userId) {
      throw new BadRequestException('USER_ID_REQUIRED');
    }
    const updated = await this.userModel
      .findByIdAndUpdate(userId, { $set: { role: 'admin' } }, { new: true })
      .select('name surname email role')
      .lean()
      .exec();
    if (!updated) {
      throw new NotFoundException('USER_NOT_FOUND');
    }
    return {
      ok: true,
      user: {
        id: (updated as any)._id?.toString(),
        name: (updated as any).name ?? '',
        surname: (updated as any).surname ?? '',
        email: (updated as any).email ?? '',
        role: this.normalizeRole((updated as any).role),
      },
    };
  }

  listLocations() {
    return this.locationModel.find().sort({ isActive: -1, name: 1 }).lean().exec();
  }

  async createLocation(dto: UpsertLocationDto) {
    const name = (dto.name ?? '').trim();
    const address = (dto.address ?? '').trim();
    if (!name || !address) {
      throw new BadRequestException('LOCATION_NAME_ADDRESS_REQUIRED');
    }
    const id = await this.buildUniqueLocationId(dto.id, name);
    const totalSlots = this.normalizeNumber(dto.totalSlots, 0);
    const availableSlots = this.normalizeNumber(dto.availableSlots, totalSlots);
    const doc = await this.locationModel.create({
      _id: id,
      name,
      address,
      latitude: this.normalizeNumber(dto.latitude, 0),
      longitude: this.normalizeNumber(dto.longitude, 0),
      totalSlots,
      availableSlots,
      usedSlots: Math.max(totalSlots - availableSlots, 0),
      maxCapacity: this.normalizeNumber(dto.maxCapacity, totalSlots),
      isActive: dto.isActive ?? true,
      timezone: (dto.timezone ?? 'Europe/Istanbul').trim(),
    });
    return doc.toObject();
  }

  async updateLocation(id: string, dto: UpsertLocationDto) {
    const location = await this.locationModel.findById(id).exec();
    if (!location) {
      throw new NotFoundException('LOCATION_NOT_FOUND');
    }

    const totalSlots = this.normalizeNumber(dto.totalSlots, location.totalSlots ?? 0);
    const availableSlots = this.normalizeNumber(
      dto.availableSlots,
      location.availableSlots ?? totalSlots,
    );
    const next = {
      ...(dto.name != null ? { name: dto.name.trim() } : {}),
      ...(dto.address != null ? { address: dto.address.trim() } : {}),
      ...(dto.latitude != null
        ? { latitude: this.normalizeNumber(dto.latitude, location.latitude ?? 0) }
        : {}),
      ...(dto.longitude != null
        ? { longitude: this.normalizeNumber(dto.longitude, location.longitude ?? 0) }
        : {}),
      ...(dto.totalSlots != null ? { totalSlots } : {}),
      ...(dto.availableSlots != null ? { availableSlots } : {}),
      ...(dto.maxCapacity != null
        ? { maxCapacity: this.normalizeNumber(dto.maxCapacity, totalSlots) }
        : {}),
      ...(dto.isActive != null ? { isActive: dto.isActive } : {}),
      ...(dto.timezone != null ? { timezone: dto.timezone.trim() } : {}),
      usedSlots: Math.max(totalSlots - availableSlots, 0),
    };

    const updated = await this.locationModel
      .findByIdAndUpdate(id, { $set: next }, { new: true })
      .lean()
      .exec();
    if (!updated) {
      throw new NotFoundException('LOCATION_NOT_FOUND');
    }
    return updated;
  }

  listCampaigns() {
    return this.campaignModel
      .find()
      .sort({ isActive: -1, sortOrder: 1, updatedAt: -1 })
      .lean()
      .exec();
  }

  async createCampaign(dto: UpsertCampaignDto, actorId: string) {
    const title = (dto.title ?? '').trim();
    const subtitle = (dto.subtitle ?? '').trim();
    const details = (dto.details ?? '').trim();
    if (!title || !subtitle || !details) {
      throw new BadRequestException('CAMPAIGN_FIELDS_REQUIRED');
    }
    const created = await this.campaignModel.create({
      title,
      subtitle,
      details,
      iconKey: (dto.iconKey ?? 'local_offer_outlined').trim(),
      gradientStart: (dto.gradientStart ?? '#0F766E').trim(),
      gradientEnd: (dto.gradientEnd ?? '#5EEAD4').trim(),
      isActive: dto.isActive ?? true,
      sortOrder: this.normalizeNumber(dto.sortOrder, 0),
      startsAt: dto.startsAt ? new Date(dto.startsAt) : undefined,
      endsAt: dto.endsAt ? new Date(dto.endsAt) : undefined,
      createdBy: actorId,
      updatedBy: actorId,
    });
    return created.toObject();
  }

  async updateCampaign(id: string, dto: UpsertCampaignDto, actorId: string) {
    const update = {
      ...(dto.title != null ? { title: dto.title.trim() } : {}),
      ...(dto.subtitle != null ? { subtitle: dto.subtitle.trim() } : {}),
      ...(dto.details != null ? { details: dto.details.trim() } : {}),
      ...(dto.iconKey != null ? { iconKey: dto.iconKey.trim() } : {}),
      ...(dto.gradientStart != null ? { gradientStart: dto.gradientStart.trim() } : {}),
      ...(dto.gradientEnd != null ? { gradientEnd: dto.gradientEnd.trim() } : {}),
      ...(dto.isActive != null ? { isActive: dto.isActive } : {}),
      ...(dto.sortOrder != null
        ? { sortOrder: this.normalizeNumber(dto.sortOrder, 0) }
        : {}),
      ...(dto.startsAt != null ? { startsAt: new Date(dto.startsAt) } : {}),
      ...(dto.endsAt != null ? { endsAt: new Date(dto.endsAt) } : {}),
      updatedBy: actorId,
    };
    const updated = await this.campaignModel
      .findByIdAndUpdate(id, { $set: update }, { new: true })
      .lean()
      .exec();
    if (!updated) {
      throw new NotFoundException('CAMPAIGN_NOT_FOUND');
    }
    return updated;
  }

  async listUsers(query?: string) {
    const search = (query ?? '').trim();
    const filter =
      search.length < 2
        ? {}
        : {
            $or: [
              { name: new RegExp(this.escapeRegex(search), 'i') },
              { surname: new RegExp(this.escapeRegex(search), 'i') },
              { email: new RegExp(this.escapeRegex(search), 'i') },
            ],
          };

    const users = await this.userModel
      .find(filter as any)
      .sort({ createdAt: -1 })
      .limit(120)
      .select(
        'name surname email role verified identityVerified verificationStatus createdAt',
      )
      .lean()
      .exec();

    const ids = users.map((item: any) => item._id?.toString()).filter(Boolean);
    const luggageCounts = ids.length
      ? await this.luggageModel
          .aggregate<{ _id: string; total: number }>([
            { $match: { userId: { $in: ids } } },
            { $group: { _id: '$userId', total: { $sum: 1 } } },
          ])
          .exec()
      : [];
    const luggageCountMap = new Map(
      luggageCounts.map((item) => [item._id?.toString(), item.total ?? 0]),
    );

    return users.map((item: any) => ({
      id: item._id?.toString(),
      name: item.name ?? '',
      surname: item.surname ?? '',
      email: item.email ?? '',
      role: this.normalizeRole(item.role),
      verified: item.verified === true,
      identityVerified: item.identityVerified === true,
      verificationStatus: item.verificationStatus ?? 'unverified',
      luggageCount: luggageCountMap.get(item._id?.toString()) ?? 0,
      createdAt: item.createdAt ?? null,
    }));
  }

  async getUserActivities(userId: string) {
    const user = await this.userModel
      .findById(userId)
      .select('name surname email role verified identityVerified verificationStatus createdAt')
      .lean()
      .exec();
    if (!user) {
      throw new NotFoundException('USER_NOT_FOUND');
    }
    const activities = await this.luggageModel
      .find({ userId })
      .sort({ updatedAt: -1 })
      .limit(80)
      .select(
        'status paymentStatus totalPrice dropLocationName storageUnit createdAt updatedAt',
      )
      .lean()
      .exec();

    return {
      user: {
        id: (user as any)._id?.toString(),
        name: (user as any).name ?? '',
        surname: (user as any).surname ?? '',
        email: (user as any).email ?? '',
        role: this.normalizeRole((user as any).role),
        verified: (user as any).verified === true,
        identityVerified: (user as any).identityVerified === true,
        verificationStatus: (user as any).verificationStatus ?? 'unverified',
        createdAt: (user as any).createdAt ?? null,
      },
      activities: activities.map((item: any) => ({
        id: item._id?.toString(),
        status: item.status ?? 'awaiting_drop',
        paymentStatus: item.paymentStatus ?? 'unpaid',
        totalPrice: item.totalPrice ?? 0,
        dropLocationName: item.dropLocationName ?? '-',
        storageUnit: item.storageUnit ?? '',
        createdAt: item.createdAt ?? null,
        updatedAt: item.updatedAt ?? null,
      })),
    };
  }

  private normalizeRole(role: unknown): 'admin' | 'editor' | 'user' {
    const value = (role ?? 'user').toString().trim().toLowerCase();
    if (value === 'admin' || value === 'editor') {
      return value;
    }
    return 'user';
  }

  private normalizeNumber(value: unknown, fallback: number): number {
    const parsed = Number(value);
    if (!Number.isFinite(parsed)) return fallback;
    return parsed;
  }

  private escapeRegex(value: string) {
    return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  private async buildUniqueLocationId(rawId: string | undefined, name: string) {
    const base = this.sanitizeId(rawId) || this.sanitizeId(name) || `loc-${Date.now()}`;
    let next = base;
    let attempt = 1;
    while (await this.locationModel.exists({ _id: next })) {
      attempt += 1;
      next = `${base}-${attempt}`;
    }
    return next;
  }

  private sanitizeId(value?: string) {
    return (value ?? '')
      .trim()
      .toLowerCase()
      .replace(/[^a-z0-9-_]+/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '');
  }
}
