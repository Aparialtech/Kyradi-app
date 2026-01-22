import { Body, Controller, Get, Param, Put, ForbiddenException, Req } from '@nestjs/common';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get(':id')
  findOne(@Param('id') id: string, @Req() req: any) {
    if (req?.user?.id !== id) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return this.usersService.findById(id);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() dto: UpdateUserDto, @Req() req: any) {
    if (req?.user?.id !== id) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return this.usersService.updateProfile(id, dto);
  }
}
