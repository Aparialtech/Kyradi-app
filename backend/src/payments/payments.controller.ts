import { Body, Controller, Post } from '@nestjs/common';

@Controller('payments')
export class PaymentsController {
  @Post('checkout')
  checkout(@Body() _body: Record<string, unknown>) {
    return { ok: true };
  }
}
