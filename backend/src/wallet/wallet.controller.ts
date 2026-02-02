import { Body, Controller, Get, Post, Req, UsePipes, ValidationPipe, ForbiddenException } from '@nestjs/common';
import { WalletService } from './wallet.service';
import { WalletTopupDto } from './dto/wallet-topup.dto';
import { WalletPayDto } from './dto/wallet-pay.dto';

@Controller('wallet')
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @Get()
  async getWallet(@Req() req: any) {
    const userId = req?.user?.id;
    if (!userId) throw new ForbiddenException('FORBIDDEN');
    return this.walletService.getWallet(userId);
  }

  @Post('topup')
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  async topup(@Body() dto: WalletTopupDto, @Req() req: any) {
    const userId = req?.user?.id;
    if (!userId) throw new ForbiddenException('FORBIDDEN');
    return this.walletService.topup(userId, dto.amount);
  }

  @Post('pay')
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  async pay(@Body() dto: WalletPayDto, @Req() req: any) {
    const userId = req?.user?.id;
    if (!userId) throw new ForbiddenException('FORBIDDEN');
    return this.walletService.pay(userId, dto.reservationId, dto.amount);
  }

  @Get('transactions')
  async transactions(@Req() req: any) {
    const userId = req?.user?.id;
    if (!userId) throw new ForbiddenException('FORBIDDEN');
    const data = await this.walletService.getWallet(userId);
    return { transactions: data.transactions };
  }
}
