import { Controller, Get, Query } from '@nestjs/common';

@Controller()
export class DirectionsController {
  @Get('directions')
  async directions(
    @Query('origin') origin: string,
    @Query('destination') destination: string,
  ) {
    if (!origin || !destination) {
      return { status: 'INVALID_REQUEST', error_message: 'origin ve destination zorunlu' };
    }

    const key = process.env.GOOGLE_DIRECTIONS_API_KEY;
    if (!key) {
      return { status: 'SERVER_ERROR', error_message: 'GOOGLE_DIRECTIONS_API_KEY env yok' };
    }

    const url =
      'https://maps.googleapis.com/maps/api/directions/json' +
      `?origin=${encodeURIComponent(origin)}` +
      `&destination=${encodeURIComponent(destination)}` +
      `&mode=driving` +
      `&key=${encodeURIComponent(key)}`;

    const r = await fetch(url);
    const data = await r.json();

    return {
      status: data.status,
      error_message: data.error_message,
      routes: data.routes,
    };
  }
}
