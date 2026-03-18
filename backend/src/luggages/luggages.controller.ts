import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Put,
  ForbiddenException,
  Req,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { LuggagesService } from './luggages.service';
import { CreateLuggageDto } from './dto/create-luggage.dto';
import { UpdateLuggageDto } from './dto/update-luggage.dto';
import { UpdateLuggageStatusDto } from './dto/update-status.dto';
import { RequestReservationChangeDto } from './dto/request-reservation-change.dto';
import { ConfirmReservationChangeDto } from './dto/confirm-reservation-change.dto';

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

  @Post(':luggageId/change-request')
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  requestChange(
    @Param('userId') userId: string,
    @Param('luggageId') luggageId: string,
    @Body() dto: RequestReservationChangeDto,
    @Req() req: any,
  ) {
    if (req?.user?.id !== userId) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return this.luggagesService.requestMetadataChange(userId, luggageId, dto);
  }

  @Post(':luggageId/change-confirm')
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  confirmChange(
    @Param('userId') userId: string,
    @Param('luggageId') luggageId: string,
    @Body() dto: ConfirmReservationChangeDto,
    @Req() req: any,
  ) {
    if (req?.user?.id !== userId) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return this.luggagesService.confirmMetadataChange(userId, luggageId, dto.code);
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

  @Post(':luggageId/cancel')
  cancel(
    @Param('userId') userId: string,
    @Param('luggageId') luggageId: string,
    @Req() req: any,
  ) {
    if (req?.user?.id !== userId) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return this.luggagesService.cancelReservation(userId, luggageId);
  }
}
