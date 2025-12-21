import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Location } from './schemas/location.schema';

@Injectable()
export class LocationsService {
  constructor(
    @InjectModel(Location.name)
    private readonly locationModel: Model<Location>,
  ) {}

  async findAll(): Promise<any[]> {
    await this.ensureSeeded();
    return this.locationModel.find().lean().exec();
  }

  findOne(id: string): Promise<any | null> {
    return this.locationModel.findById(id).lean().exec();
  }

  private async ensureSeeded() {
    const count = await this.locationModel.countDocuments().exec();
    if (count > 0) return;
    const seedData = [
      {
        _id: 'taksim',
        name: 'Taksim BavulGO',
        address: 'Cumhuriyet Cd. No: 1, Beyoğlu',
        latitude: 41.0369,
        longitude: 28.9856,
        totalSlots: 12,
        availableSlots: 3,
        usedSlots: 12 - 3,
      },
      {
        _id: 'kagithane',
        name: 'Kağıthane BavulGO',
        address: 'Merkez Mah. Kağıthane',
        latitude: 41.1085,
        longitude: 28.9722,
        totalSlots: 8,
        availableSlots: 1,
        usedSlots: 8 - 1,
      },
      {
        _id: 'besiktas',
        name: 'Beşiktaş BavulGO',
        address: 'Çırağan Cad., Beşiktaş',
        latitude: 41.041,
        longitude: 29.0078,
        totalSlots: 10,
        availableSlots: 4,
        usedSlots: 10 - 4,
      },
      {
        _id: 'kadikoy',
        name: 'Kadıköy BavulGO',
        address: 'Kadıköy Rıhtım Cd.',
        latitude: 40.9929,
        longitude: 29.02799,
        totalSlots: 16,
        availableSlots: 6,
        usedSlots: 16 - 6,
      },
      {
        _id: 'sisli',
        name: 'Şişli BavulGO',
        address: 'Halaskargazi Cd., Şişli',
        latitude: 41.0601,
        longitude: 28.9876,
        totalSlots: 5,
        availableSlots: 0,
        usedSlots: 5,
      },
      {
        _id: 'bakirkoy',
        name: 'Bakırköy BavulGO',
        address: 'İncirli Cd., Bakırköy',
        latitude: 40.978,
        longitude: 28.8724,
        totalSlots: 9,
        availableSlots: 2,
        usedSlots: 9 - 2,
      },
    ];
    await this.locationModel.insertMany(seedData);
  }
}
