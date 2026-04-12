export type ApiUser = {
  _id: string;
  id?: string;
  name?: string;
  surname?: string;
  email?: string;
  phone?: string;
  address?: string;
  role?: string;
  verified?: boolean;
  identityVerified?: boolean;
};

export type LoginResponse = {
  accessToken: string;
  user: ApiUser;
  pendingVerification?: boolean;
  message?: string;
};

export type LuggageItem = {
  _id?: string;
  id?: string;
  label?: string;
  qrCode?: string;
  status?: string;
  size?: string;
  note?: string;
  color?: string;
  dropLocationId?: string;
  dropLocationName?: string;
  paymentMethod?: string;
  paymentStatus?: string;
  totalPrice?: number;
  delegateActive?: boolean;
  scheduledDropTime?: string;
  scheduledPickupTime?: string;
  dropConfirmedAt?: string;
  pickupConfirmedAt?: string;
  createdAt?: string;
  updatedAt?: string;
  storageUnit?: string;
};

export type WalletTx = {
  _id?: string;
  type?: string;
  amount?: number;
  note?: string;
  reservationId?: string;
  createdAt?: string;
};

export type WalletOverview = {
  balance: number;
  transactions: WalletTx[];
};

export type LocationItem = {
  _id?: string;
  id?: string;
  name?: string;
  address?: string;
  latitude?: number;
  longitude?: number;
  totalSlots?: number;
  availableSlots?: number;
  usedSlots?: number;
  maxCapacity?: number;
  isActive?: boolean;
};

export type PaymentMethod = 'card' | 'installment' | 'pay_at_hotel' | 'transfer' | 'wallet';

export type LuggageStatus = 'awaiting_drop' | 'dropped' | 'picked_up' | 'cancelled';

export type LuggageCreatePayload = {
  qrCode?: string;
  label?: string;
  size?: string;
  weight?: string;
  color?: string;
  note?: string;
  ownerName?: string;
  ownerPhone?: string;
  ownerEmail?: string;
  paymentMethod?: PaymentMethod;
  totalPrice?: number;
  dropLocationId: string;
  dropLocationName: string;
  scheduledDropTime?: string;
  scheduledPickupTime?: string;
};

export type ReservationChangePayload = {
  label?: string;
  size?: string;
  weight?: string;
  color?: string;
  note?: string;
  dropLocationId?: string;
  dropLocationName?: string;
  scheduledDropTime?: string;
  scheduledPickupTime?: string;
  pickupDelegateFullName?: string;
  pickupDelegatePhone?: string;
  pickupDelegateEmail?: string;
};
