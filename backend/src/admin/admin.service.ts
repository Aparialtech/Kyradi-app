import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from '../users/schemas/user.schema';
import { Luggage, LuggageStatus, PaymentStatus } from '../luggages/schemas/luggage.schema';
import { Location } from '../locations/schemas/location.schema';
import { Campaign } from '../campaigns/schemas/campaign.schema';
import { UpsertLocationDto } from './dto/upsert-location.dto';
import { UpsertCampaignDto } from './dto/upsert-campaign.dto';
import {
  AdminUpdateReservationStatusDto,
} from './dto/admin-update-reservation-status.dto';
import { AdminBulkUpdateReservationStatusDto } from './dto/admin-bulk-update-reservation-status.dto';
import { AdminAuditEvent } from './schemas/admin-audit-event.schema';

@Injectable()
export class AdminService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<User>,
    @InjectModel(Luggage.name) private readonly luggageModel: Model<Luggage>,
    @InjectModel(Location.name) private readonly locationModel: Model<Location>,
    @InjectModel(Campaign.name) private readonly campaignModel: Model<Campaign>,
    @InjectModel(AdminAuditEvent.name)
    private readonly auditModel: Model<AdminAuditEvent>,
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
      paymentRaw,
      revenueRaw,
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
        .aggregate<{ _id: string; total: number }>([
          { $group: { _id: '$paymentStatus', total: { $sum: 1 } } },
        ])
        .exec(),
      this.luggageModel
        .aggregate<{ _id: string; totalAmount: number }>([
          {
            $match: {
              paymentStatus: 'paid',
              totalPrice: { $type: 'number' },
            },
          },
          {
            $group: {
              _id: null,
              totalAmount: { $sum: '$totalPrice' },
            },
          },
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
    const paymentCounts = paymentRaw.reduce<Record<string, number>>((acc, item) => {
      const key = (item?._id ?? 'unknown').toString();
      acc[key] = item.total ?? 0;
      return acc;
    }, {});
    const totalRevenue = revenueRaw[0]?.totalAmount ?? 0;

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
        paymentCounts,
        totalRevenue,
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
    await this.appendAuditEvent({
      type: 'location',
      action: 'create',
      entityId: doc._id?.toString() ?? id,
      actorId: 'system',
      summary: `${name} lokasyonu eklendi`,
      meta: {
        isActive: dto.isActive ?? true,
      },
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
    await this.appendAuditEvent({
      type: 'location',
      action: 'update',
      entityId: id,
      actorId: 'system',
      summary: `${updated.name ?? id} lokasyonu guncellendi`,
      meta: {
        isActive: updated.isActive ?? true,
        availableSlots: (updated as any).availableSlots ?? 0,
      },
    });
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
    await this.appendAuditEvent({
      type: 'campaign',
      action: 'create',
      entityId: created._id?.toString() ?? '',
      actorId,
      summary: `${title} kampanyasi eklendi`,
      meta: {
        isActive: dto.isActive ?? true,
      },
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
    await this.appendAuditEvent({
      type: 'campaign',
      action: 'update',
      entityId: id,
      actorId,
      summary: `${(updated as any).title ?? id} kampanyasi guncellendi`,
      meta: {
        isActive: (updated as any).isActive ?? true,
      },
    });
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

  async listReservations(params: {
    q?: string;
    status?: string;
    days?: string;
    limit?: string;
  }) {
    const q = (params.q ?? '').trim().toLowerCase();
    const status = (params.status ?? '').trim().toLowerCase();
    const days = this.parsePositiveInt(params.days, 0);
    const limit = this.parsePositiveInt(params.limit, 80);
    const safeLimit = Math.min(Math.max(limit, 1), 250);
    const validStatuses = new Set(Object.values(LuggageStatus));

    const query: Record<string, any> = {};
    if (status && status !== 'all') {
      const normalizedStatus = this.normalizeAdminStatus(status);
      if (!validStatuses.has(normalizedStatus)) {
        throw new BadRequestException('INVALID_STATUS_FILTER');
      }
      query.status = normalizedStatus;
    }
    if (days > 0) {
      query.updatedAt = {
        $gte: new Date(Date.now() - days * 24 * 60 * 60 * 1000),
      };
    }

    const rows = await this.luggageModel
      .find(query)
      .sort({ updatedAt: -1 })
      .limit(safeLimit)
      .select(
        'userId status paymentStatus totalPrice dropLocationName storageUnit createdAt updatedAt',
      )
      .lean()
      .exec();

    const userIds = Array.from(
      new Set(rows.map((item: any) => item.userId?.toString()).filter(Boolean)),
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
        {
          name: `${item.name ?? ''} ${item.surname ?? ''}`.trim() || 'Kullanici',
          email: item.email ?? '',
        },
      ]),
    );

    const mapped = rows
      .map((item: any) => {
        const user = userMap.get(item.userId?.toString() ?? '') ?? {
          name: 'Kullanici',
          email: '',
        };
        return {
          id: item._id?.toString(),
          userId: item.userId?.toString() ?? '',
          userName: user.name,
          userEmail: user.email,
          status: item.status ?? LuggageStatus.AWAITING,
          paymentStatus: item.paymentStatus ?? PaymentStatus.UNPAID,
          totalPrice: item.totalPrice ?? 0,
          dropLocationName: item.dropLocationName ?? '-',
          storageUnit: item.storageUnit ?? '',
          createdAt: item.createdAt ?? null,
          updatedAt: item.updatedAt ?? null,
        };
      })
      .filter((item) => {
        if (q.length < 2) return true;
        const haystack = [
          item.id,
          item.userName,
          item.userEmail,
          item.dropLocationName,
          item.status,
          item.paymentStatus,
        ]
          .join(' ')
          .toLowerCase();
        return haystack.includes(q);
      });

    return {
      reservations: mapped,
      total: mapped.length,
    };
  }

  async updateReservationStatus(
    reservationId: string,
    dto: AdminUpdateReservationStatusDto,
    actorId: string,
  ) {
    const luggage = await this.luggageModel.findById(reservationId).exec();
    if (!luggage) {
      throw new NotFoundException('RESERVATION_NOT_FOUND');
    }

    const nextStatus = this.normalizeAdminStatus(dto.status);
    if (nextStatus === LuggageStatus.DROPPED) {
      const paid =
        luggage.paymentStatus === PaymentStatus.PAID ||
        !!luggage.paidAt ||
        (!!luggage.transactionId && luggage.transactionId.trim().length > 0);
      if (!paid) {
        throw new BadRequestException({
          message: 'PAYMENT_REQUIRED_BEFORE_DROP',
          code: 'PAYMENT_REQUIRED_BEFORE_DROP',
          action: 'OPEN_PAYMENT',
          reservationId: luggage._id?.toString() ?? reservationId,
          paymentStatus: luggage.paymentStatus ?? PaymentStatus.UNPAID,
          amountDue: luggage.totalPrice ?? 0,
        });
      }
    }

    const now = new Date();
    luggage.status = nextStatus;
    const storageUnit = (dto.storageUnit ?? '').trim();
    if (storageUnit) {
      luggage.storageUnit = storageUnit;
    }
    if (nextStatus === LuggageStatus.DROPPED && !luggage.dropConfirmedAt) {
      luggage.dropConfirmedAt = now;
    } else if (nextStatus === LuggageStatus.PICKED && !luggage.pickupConfirmedAt) {
      luggage.pickupConfirmedAt = now;
    }
    luggage.integration = {
      ...(luggage.integration ?? {}),
      adminLastActionBy: actorId,
      adminLastActionAt: now,
    } as any;

    const saved = await luggage.save();
    await this.refreshLocationOccupancy(saved.dropLocationId?.toString());
    await this.appendAuditEvent({
      type: 'reservation',
      action: 'status_update',
      entityId: saved._id?.toString() ?? reservationId,
      actorId,
      summary: `Rezervasyon durumu ${nextStatus} yapildi`,
      meta: {
        paymentStatus: saved.paymentStatus ?? PaymentStatus.UNPAID,
        storageUnit: saved.storageUnit ?? '',
      },
    });

    return {
      ok: true,
      reservation: {
        id: saved._id?.toString(),
        status: saved.status,
        paymentStatus: saved.paymentStatus,
        storageUnit: saved.storageUnit ?? '',
        updatedAt: (saved as any).updatedAt ?? now,
      },
    };
  }

  async bulkUpdateReservationStatus(
    dto: AdminBulkUpdateReservationStatusDto,
    actorId: string,
  ) {
    const ids = Array.from(
      new Set((dto.reservationIds ?? []).map((item) => (item ?? '').toString().trim())),
    ).filter(Boolean);
    if (ids.length === 0) {
      throw new BadRequestException('RESERVATION_IDS_REQUIRED');
    }
    if (ids.length > 120) {
      throw new BadRequestException('TOO_MANY_RESERVATIONS');
    }

    const success: Array<{ id: string; status: string }> = [];
    const failed: Array<{ id: string; error: string }> = [];
    for (const id of ids) {
      try {
        const result = await this.updateReservationStatus(
          id,
          {
            status: dto.status,
            storageUnit: dto.storageUnit,
          },
          actorId,
        );
        success.push({
          id,
          status: result.reservation?.status?.toString() ?? dto.status.toString(),
        });
      } catch (error) {
        const message =
          (error as any)?.response?.message ??
          (error as any)?.message ??
          'UPDATE_FAILED';
        failed.push({ id, error: message.toString() });
      }
    }

    await this.appendAuditEvent({
      type: 'reservation',
      action: 'bulk_status_update',
      entityId: `${success.length}/${ids.length}`,
      actorId,
      summary: `${success.length} rezervasyon toplu guncellendi`,
      meta: {
        requested: ids.length,
        success: success.length,
        failed: failed.length,
        status: dto.status,
      },
    });

    return {
      ok: failed.length === 0,
      successCount: success.length,
      failedCount: failed.length,
      success,
      failed,
    };
  }

  async getAuditLog(params: { days?: string; limit?: string }) {
    const days = this.parsePositiveInt(params.days, 30);
    const limit = this.parsePositiveInt(params.limit, 80);
    const safeLimit = Math.min(Math.max(limit, 1), 250);
    const threshold = new Date(Date.now() - days * 24 * 60 * 60 * 1000);

    const storedEntries = await this.auditModel
      .find({ createdAt: { $gte: threshold } })
      .sort({ createdAt: -1 })
      .limit(safeLimit)
      .lean()
      .exec();
    if (storedEntries.length > 0) {
      return {
        entries: storedEntries.map((item: any) => ({
          id: item._id?.toString(),
          type: item.type ?? 'unknown',
          action: item.action ?? 'update',
          title: this.auditTitle(item.type, item.action),
          subtitle: item.summary ?? '-',
          createdAt: item.createdAt ?? null,
          actorId: item.actorId ?? '',
          meta: item.meta ?? {},
        })),
        total: storedEntries.length,
      };
    }

    const [recentLuggages, recentCampaigns, recentLocations] = await Promise.all([
      this.luggageModel
        .find({ updatedAt: { $gte: threshold } })
        .sort({ updatedAt: -1 })
        .limit(safeLimit)
        .select('status paymentStatus dropLocationName userId totalPrice updatedAt createdAt')
        .lean()
        .exec(),
      this.campaignModel
        .find({ updatedAt: { $gte: threshold } })
        .sort({ updatedAt: -1 })
        .limit(safeLimit)
        .select('title subtitle isActive updatedBy updatedAt createdAt')
        .lean()
        .exec(),
      this.locationModel
        .find({ updatedAt: { $gte: threshold } })
        .sort({ updatedAt: -1 })
        .limit(safeLimit)
        .select('name address isActive availableSlots totalSlots updatedAt createdAt')
        .lean()
        .exec(),
    ]);

    const userIds = Array.from(
      new Set(
        recentLuggages.map((item: any) => item.userId?.toString()).filter(Boolean),
      ),
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

    const entries = [
      ...recentLuggages.map((item: any) => ({
        id: `res-${item._id?.toString() ?? ''}`,
        type: 'reservation',
        title: 'Rezervasyon guncellendi',
        subtitle: `${userMap.get(item.userId?.toString()) ?? 'Kullanici'} • ${item.status ?? '-'} • ${item.dropLocationName ?? '-'}`,
        createdAt: item.updatedAt ?? item.createdAt ?? null,
      })),
      ...recentCampaigns.map((item: any) => ({
        id: `cmp-${item._id?.toString() ?? ''}`,
        type: 'campaign',
        title: 'Kampanya guncellendi',
        subtitle: `${item.title ?? 'Kampanya'} • ${item.isActive === false ? 'pasif' : 'aktif'}`,
        createdAt: item.updatedAt ?? item.createdAt ?? null,
      })),
      ...recentLocations.map((item: any) => ({
        id: `loc-${item._id?.toString() ?? ''}`,
        type: 'location',
        title: 'Lokasyon guncellendi',
        subtitle: `${item.name ?? '-'} • ${item.availableSlots ?? 0}/${item.totalSlots ?? 0} slot`,
        createdAt: item.updatedAt ?? item.createdAt ?? null,
      })),
    ]
      .sort((a, b) => {
        const aDate = a.createdAt ? new Date(a.createdAt).getTime() : 0;
        const bDate = b.createdAt ? new Date(b.createdAt).getTime() : 0;
        return bDate - aDate;
      })
      .slice(0, safeLimit);

    return {
      entries,
      total: entries.length,
    };
  }

  private normalizeRole(role: unknown): 'admin' | 'editor' | 'user' {
    const value = (role ?? 'user').toString().trim().toLowerCase();
    if (value === 'admin' || value === 'editor') {
      return value;
    }
    return 'user';
  }

  private parsePositiveInt(value: unknown, fallback: number) {
    const parsed = Number(value);
    if (!Number.isFinite(parsed)) return fallback;
    if (parsed < 0) return fallback;
    return Math.floor(parsed);
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

  private normalizeAdminStatus(
    status: LuggageStatus | 'assigned' | string,
  ): LuggageStatus {
    if (status === 'assigned') {
      return LuggageStatus.AWAITING;
    }
    return status as LuggageStatus;
  }

  private auditTitle(type?: string, action?: string) {
    if (type === 'reservation') {
      return action === 'bulk_status_update'
        ? 'Toplu rezervasyon islemi'
        : 'Rezervasyon guncellendi';
    }
    if (type === 'campaign') {
      return action === 'create'
        ? 'Kampanya eklendi'
        : 'Kampanya guncellendi';
    }
    if (type === 'location') {
      return action === 'create'
        ? 'Lokasyon eklendi'
        : 'Lokasyon guncellendi';
    }
    return 'Yonetim islemi';
  }

  private async appendAuditEvent(event: {
    type: string;
    action: string;
    entityId: string;
    actorId?: string;
    summary?: string;
    meta?: Record<string, unknown>;
  }) {
    try {
      await this.auditModel.create({
        type: event.type,
        action: event.action,
        entityId: event.entityId,
        actorId: event.actorId ?? 'system',
        summary: event.summary ?? '',
        meta: event.meta ?? {},
      });
    } catch {
      // Best-effort audit; never block admin operations.
    }
  }

  private async refreshLocationOccupancy(locationId?: string | null) {
    if (!locationId) return;
    const normalized = locationId.toString();
    const location = await this.locationModel.findById(normalized).lean().exec();
    if (!location) return;
    const usedSlots = await this.getLocationOccupancy(normalized);
    const capacity =
      typeof (location as any).maxCapacity === 'number'
        ? ((location as any).maxCapacity as number)
        : ((location as any).totalSlots ?? 0);
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

  private async getLocationOccupancy(locationId: string) {
    return this.luggageModel
      .countDocuments({
        dropLocationId: locationId,
        status: { $in: [LuggageStatus.AWAITING, LuggageStatus.DROPPED] },
      })
      .exec();
  }
}
