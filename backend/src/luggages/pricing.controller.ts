import { Body, Controller, Logger, Post, UsePipes, ValidationPipe } from '@nestjs/common';
import { LuggagesService } from './luggages.service';
import { PricingEstimateDto } from './dto/pricing-estimate.dto';

@Controller('pricing')
export class PricingController {
  private readonly logger = new Logger(PricingController.name);

  constructor(private readonly luggagesService: LuggagesService) {
    this.logger.log('PricingController registered');
  }

  @Post('estimate')
  @UsePipes(new ValidationPipe({ transform: true }))
  estimatePricing(@Body() dto: PricingEstimateDto) {
    return this.luggagesService.estimatePricing(dto);
  }
}
