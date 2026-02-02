import { Body, Controller, Get, Param, Post, Req, ForbiddenException, UsePipes, ValidationPipe } from '@nestjs/common';
import { LuggagesService } from '../luggages/luggages.service';
import { CreateLuggageDto } from '../luggages/dto/create-luggage.dto';

@Controller('reservations')
export class ReservationsController {
  constructor(private readonly luggagesService: LuggagesService) {}

  @Get('me')
  async getMine(@Req() req: any) {
    const userId = req?.user?.id;
    if (!userId) throw new ForbiddenException('FORBIDDEN');
    return this.luggagesService.findByUser(userId);
  }

  @Get(':id')
  async getOne(@Param('id') id: string, @Req() req: any) {
    const userId = req?.user?.id;
    if (!userId) throw new ForbiddenException('FORBIDDEN');
    return this.luggagesService.findByIdForUser(userId, id);
  }

  @Post()
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  async create(@Body() dto: CreateLuggageDto, @Req() req: any) {
    const userId = req?.user?.id;
    if (!userId) throw new ForbiddenException('FORBIDDEN');
    return this.luggagesService.create(userId, dto);
  }

  @Post(':id/cancel')
  async cancel(@Param('id') id: string, @Req() req: any) {
    const userId = req?.user?.id;
    if (!userId) throw new ForbiddenException('FORBIDDEN');
    return this.luggagesService.cancelReservation(userId, id);
  }
}
