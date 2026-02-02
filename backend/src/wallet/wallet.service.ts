import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Luggage, PaymentMethod, PaymentStatus } from '../luggages/schemas/luggage.schema';
import { Wallet, WalletTransaction } from './schemas/wallet.schema';

@Injectable()
export class WalletService {
  constructor(
    @InjectModel(Wallet.name)
    private readonly walletModel: Model<Wallet>,
    @InjectModel(WalletTransaction.name)
    private readonly transactionModel: Model<WalletTransaction>,
    @InjectModel(Luggage.name)
    private readonly luggageModel: Model<Luggage>,
  ) {}

  private async getOrCreateWallet(userId: string) {
    const existing = await this.walletModel.findOne({ userId }).exec();
    if (existing) return existing;
    return this.walletModel.create({ userId, balance: 0 });
  }

  async getWallet(userId: string) {
    const wallet = await this.getOrCreateWallet(userId);
    const transactions = await this.transactionModel
      .find({ userId })
      .sort({ createdAt: -1 })
      .limit(20)
      .lean()
      .exec();
    return { balance: wallet.balance, transactions };
  }

  async topup(userId: string, amount: number) {
    const wallet = await this.getOrCreateWallet(userId);
    wallet.balance = Math.max(0, Math.round(wallet.balance + amount));
    await wallet.save();
    await this.transactionModel.create({
      userId,
      type: 'topup',
      amount,
    });
    return { balance: wallet.balance };
  }

  async pay(userId: string, reservationId: string, amount?: number) {
    const wallet = await this.getOrCreateWallet(userId);
    const luggage = await this.luggageModel.findOne({ _id: reservationId, userId }).exec();
    if (!luggage) throw new NotFoundException('RESERVATION_NOT_FOUND');
    const payable = typeof amount === 'number' && amount > 0 ? amount : (luggage.totalPrice ?? 0);
    if (payable <= 0) throw new BadRequestException('INVALID_AMOUNT');
    if (wallet.balance < payable) throw new BadRequestException('WALLET_INSUFFICIENT');
    wallet.balance = Math.max(0, Math.round(wallet.balance - payable));
    await wallet.save();
    await this.transactionModel.create({
      userId,
      type: 'pay',
      amount: payable,
      reservationId,
    });
    luggage.paymentMethod = PaymentMethod.WALLET;
    luggage.paymentStatus = PaymentStatus.PAID;
    luggage.paidAt = new Date();
    await luggage.save();
    return { balance: wallet.balance, paymentStatus: luggage.paymentStatus };
  }
}
