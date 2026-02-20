import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Campaign } from './schemas/campaign.schema';

@Injectable()
export class CampaignsService {
  constructor(
    @InjectModel(Campaign.name)
    private readonly campaignModel: Model<Campaign>,
  ) {}

  async findPublic() {
    await this.ensureSeeded();
    const now = new Date();
    return this.campaignModel
      .find({
        isActive: true,
        $and: [
          { $or: [{ startsAt: null }, { startsAt: { $exists: false } }, { startsAt: { $lte: now } }] },
          { $or: [{ endsAt: null }, { endsAt: { $exists: false } }, { endsAt: { $gte: now } }] },
        ],
      })
      .sort({ sortOrder: 1, updatedAt: -1 })
      .lean()
      .exec();
  }

  private async ensureSeeded() {
    const count = await this.campaignModel.countDocuments().exec();
    if (count > 0) return;
    await this.campaignModel.insertMany([
      {
        title: 'Kahve Dünyası Kahve Hediyesi',
        subtitle: 'İlk rezervasyonuna özel 1 kahve ücretsiz.',
        details:
          'İlk rezervasyonunu tamamladığında, Kahve Dünyası’ndan 1 adet kahve ücretsiz kazanırsın.',
        iconKey: 'local_cafe_outlined',
        gradientStart: '#7A4E2D',
        gradientEnd: '#D4A373',
        isActive: true,
        sortOrder: 10,
      },
      {
        title: '3 Gün ve Üzeri %50 İndirim',
        subtitle: '3 gün ve daha uzun rezervasyonlarda %50 indirim.',
        details: '3 gün ve üzeri bavul bırakma rezervasyonlarında toplam ücret üzerinden %50 indirim uygulanır.',
        iconKey: 'local_offer_outlined',
        gradientStart: '#1D4ED8',
        gradientEnd: '#60A5FA',
        isActive: true,
        sortOrder: 20,
      },
      {
        title: 'Öğrencilere Özel %30 İndirim',
        subtitle: 'Edu mail ile kayıt olana %30 indirim.',
        details: 'Edu uzantılı e-posta ile kayıt olan öğrencilere özel indirim tanımlanır.',
        iconKey: 'school_outlined',
        gradientStart: '#B45309',
        gradientEnd: '#FBBF24',
        isActive: true,
        sortOrder: 30,
      },
    ]);
  }
}
