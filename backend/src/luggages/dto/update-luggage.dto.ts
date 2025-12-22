export class UpdateLuggageDto {
  label?: string;
  size?: string;
  weight?: string;
  color?: string;
  note?: string;
  dropLocationId?: string;
  dropLocationName?: string;
  scheduledDropTime?: Date | string;
  scheduledPickupTime?: Date | string;
  pickupDelegateFullName?: string;
  pickupDelegatePhone?: string;
  pickupDelegateEmail?: string;
}
