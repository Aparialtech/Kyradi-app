import { Body, Controller, Get, Param, Post, Put, ForbiddenException, Req } from '@nestjs/common';
import { LuggagesService } from './luggages.service';
import { CreateLuggageDto } from './dto/create-luggage.dto';
import { UpdateLuggageDto } from './dto/update-luggage.dto';
import { UpdateLuggageStatusDto } from './dto/update-status.dto';

@Controller('users/:userId/luggages')
export class LuggagesController {
  constructor(private readonly luggagesService: LuggagesService) {}

  @Get()
  findAll(@Param('userId') userId: string, @Req() req: any) {
    if (req?.user?.id !== userId) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return this.luggagesService.findByUser(userId);
  }

  @Post()
  create(@Param('userId') userId: string, @Body() dto: CreateLuggageDto, @Req() req: any) {
    if (req?.user?.id !== userId) {
      throw new ForbiddenException('FORBIDDEN');
    }
    console.log('[PIN_MAIL] endpoint hit', {
      path: '/users/:userId/luggages',
      user: userId,
      body: dto,
    });
    return this.luggagesService.create(userId, dto);
  }

  @Put(':luggageId')
  updateMetadata(
    @Param('userId') userId: string,
    @Param('luggageId') luggageId: string,
    @Body() dto: UpdateLuggageDto,
    @Req() req: any,
  ) {
    if (req?.user?.id !== userId) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return this.luggagesService.updateMetadata(userId, luggageId, dto);
  }

  @Put(':luggageId/status')
  updateStatus(
    @Param('userId') userId: string,
    @Param('luggageId') luggageId: string,
    @Body() dto: UpdateLuggageStatusDto,
    @Req() req: any,
  ) {
    if (req?.user?.id !== userId) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return this.luggagesService.updateStatus(
      userId,
      luggageId,
      dto.status,
      dto.pickupPin,
      dto.delegateCode,
    );
  }
}
