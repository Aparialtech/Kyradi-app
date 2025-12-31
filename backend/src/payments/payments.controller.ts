import { BadRequestException, Body, Controller, Get, Post, Query } from '@nestjs/common';

@Controller('payments')
export class PaymentsController {
  @Post('checkout')
  checkout(@Body() _body: Record<string, unknown>) {
    return { ok: true };
  }

  @Get('status')
  status(@Query('reservationId') reservationId?: string) {
    if (!reservationId?.trim()) {
      throw new BadRequestException({ message: 'reservationId is required' });
    }
    return { ok: true, reservationId, status: 'unknown' };
  }
}
