export class CreateLuggageDto {
  qrCode?: string;
  label?: string;
  size?: string;
  weight?: string;
  color?: string;
  note?: string;
  ownerName?: string;
  ownerPhone?: string;
  ownerEmail?: string;
  paymentMethod?: 'card' | 'installment' | 'pay_at_hotel';
  totalPrice?: number;
  dropLocationId: string;
  dropLocationName: string;
  scheduledDropTime?: Date | string;
  scheduledPickupTime?: Date | string;
}
