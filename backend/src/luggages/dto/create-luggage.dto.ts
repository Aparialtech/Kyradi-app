export class CreateLuggageDto {
  qrCode?: string;
  label?: string;
  size?: string;
  weight?: string;
  color?: string;
  note?: string;
  dropLocationId: string;
  dropLocationName: string;
  scheduledDropTime?: Date | string;
  scheduledPickupTime?: Date | string;
}
