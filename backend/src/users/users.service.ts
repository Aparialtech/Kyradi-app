import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './schemas/user.schema';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { hashPassword } from '../common/utils/password.util';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name)
    private readonly userModel: Model<User>,
  ) {}

  async create(dto: CreateUserDto) {
    const existing = await this.userModel
      .findOne({ email: dto.email.toLowerCase() })
      .lean()
      .exec();
    if (existing) {
      throw new ConflictException('Bu e-posta adresi zaten kayıtlı');
    }
    const created = await this.userModel.create({
      name: dto.name,
      surname: dto.surname,
      email: dto.email.toLowerCase(),
      passwordHash: hashPassword(dto.password),
      phone: dto.phone,
      verified: false,
    });
    return this.toSafeObject(created as unknown as User);
  }

  async findByEmail(email: string) {
    return this.userModel.findOne({ email: email.toLowerCase() }).exec();
  }

  async findByProvider(provider: string, sub: string) {
    return this.userModel.findOne({
      oauthAccounts: { $elemMatch: { provider, sub } },
    }).exec();
  }

  async createSocialUser(params: {
    name: string;
    surname: string;
    email: string;
    provider: string;
    sub: string;
  }) {
    const created = await this.userModel.create({
      name: params.name,
      surname: params.surname,
      email: params.email.toLowerCase(),
      passwordHash: hashPassword(`${params.provider}-${Date.now()}-${Math.random()}`),
      verified: true,
      oauthAccounts: [{ provider: params.provider, sub: params.sub, email: params.email }],
    });
    return created;
  }

  async attachProvider(
    user: User,
    provider: string,
    sub: string,
    email?: string,
  ) {
    const accounts = Array.isArray(user.oauthAccounts) ? user.oauthAccounts : [];
    const exists = accounts.some(
      (acc) => acc.provider === provider && acc.sub === sub,
    );
    if (!exists) {
      accounts.push({ provider, sub, email });
      user.oauthAccounts = accounts;
      await user.save();
    }
    return user;
  }

  async findById(id: string) {
    const user = await this.userModel.findById(id).lean().exec();
    if (!user) throw new NotFoundException('User not found');
    return this.toSafeObject(user as unknown as User);
  }

  findDocumentById(id: string) {
    return this.userModel.findById(id).exec();
  }

  async updateProfile(id: string, dto: UpdateUserDto) {
    const updated = await this.userModel
      .findByIdAndUpdate(
        id,
        {
          $set: {
            ...(dto.name && { name: dto.name }),
            ...(dto.surname && { surname: dto.surname }),
            ...(dto.email && { email: dto.email.toLowerCase() }),
            ...(dto.phone && { phone: dto.phone }),
            ...(dto.address && { address: dto.address }),
            ...(dto.gender && { gender: dto.gender }),
            ...(dto.pushReminderEnabled !== undefined && {
              pushReminderEnabled: dto.pushReminderEnabled,
            }),
            ...(dto.emailReminderEnabled !== undefined && {
              emailReminderEnabled: dto.emailReminderEnabled,
            }),
            ...(dto.identityDocumentUrl !== undefined && {
              identityDocumentUrl: dto.identityDocumentUrl,
            }),
            ...(dto.emergencyContact && {
              emergencyContact: {
                fullName: dto.emergencyContact.fullName ?? '',
                phone: dto.emergencyContact.phone ?? '',
                email: dto.emergencyContact.email ?? '',
                address: dto.emergencyContact.address ?? '',
                relation: dto.emergencyContact.relation ?? '',
              },
            }),
          },
        },
        { new: true },
      )
      .lean()
      .exec();
    if (!updated) throw new NotFoundException('User not found');
    return this.toSafeObject(updated as unknown as User);
  }

  toSafeObject(user: User | (User & { toObject?: () => any })) {
    const obj =
      typeof user.toObject === 'function' ? (user.toObject() as Record<string, any>) : (user as any);
    delete obj.passwordHash;
    return obj;
  }
}
