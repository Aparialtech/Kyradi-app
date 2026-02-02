import { Body, Controller, Get, Post, UsePipes, ValidationPipe } from '@nestjs/common';
import { ChatService } from './chat.service';
import { ChatMessageDto } from './dto/chat-message.dto';
import { Public } from '../common/decorators/public.decorator';

@Controller()
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Get('chat/health')
  @Public()
  health() {
    return this.chatService.health();
  }

  @Post('chat/message')
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  send(@Body() dto: ChatMessageDto) {
    return this.chatService.sendMessage(dto.message, dto.sessionId);
  }

  @Post('support/chat')
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  supportChat(@Body() dto: ChatMessageDto) {
    return this.chatService.sendMessage(dto.message, dto.sessionId);
  }
}
