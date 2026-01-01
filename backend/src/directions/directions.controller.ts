import { BadRequestException, Controller, Get, InternalServerErrorException, Query } from '@nestjs/common';

@Controller('directions')
export class DirectionsController {
  @Get()
  async getDirections(
    @Query('origin') origin?: string,
    @Query('destination') destination?: string,
  ) {
    if (!origin || !destination) {
      throw new BadRequestException('origin and destination are required');
    }
    const apiKey = process.env.GOOGLE_DIRECTIONS_API_KEY;
    if (!apiKey) {
      throw new InternalServerErrorException('GOOGLE_DIRECTIONS_API_KEY is missing');
    }

    const params = new URLSearchParams({
      origin,
      destination,
      key: apiKey,
    });
    const url = `https://maps.googleapis.com/maps/api/directions/json?${params.toString()}`;

    const res = await fetch(url);
    const data = await res.json();

    return {
      status: data.status,
      error_message: data.error_message,
      routes: data.routes ?? [],
    };
  }
}
