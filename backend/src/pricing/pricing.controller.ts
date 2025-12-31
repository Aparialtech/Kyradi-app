import { BadRequestException, Controller, Get, Query } from '@nestjs/common';
import { PricingService } from './pricing.service';

@Controller('pricing')
export class PricingController {
  constructor(private readonly pricingService: PricingService) {}

  @Get('quote')
  quote(
    @Query('sizeClass') sizeClass?: string,
    @Query('startAt') startAt?: string,
    @Query('endAt') endAt?: string,
  ) {
    if (!sizeClass || !startAt || !endAt) {
      throw new BadRequestException('MISSING_PRICING_PARAMS');
    }
    return this.pricingService.quote(sizeClass, new Date(startAt), new Date(endAt));
  }
}
