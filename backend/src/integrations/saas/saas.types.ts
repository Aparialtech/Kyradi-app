export type SaasReservationPayload = {
  reservationId: string;
  user: {
    id: string;
    name?: string;
    surname?: string;
    email?: string;
    phone?: string;
  };
  luggage: {
    count?: number;
    size?: string;
    notes?: string;
  };
  location: {
    id?: string;
    name?: string;
    city?: string;
    lat?: number;
    lng?: number;
  };
  dropAt?: string | null;
  pickupAt?: string | null;
  pricing: {
    base?: number;
    insurance?: number;
    hotelPayFee?: number;
    total?: number;
    currency: 'TRY';
  };
  paid: true;
};

export type SaasStatusUpdate = {
  reservationId?: string;
  saasReservationId?: string;
  externalReservationId?: string;
  status: 'assigned' | 'dropped' | 'picked_up' | 'completed' | 'cancelled' | 'rejected';
  storageUnit?: string;
  operator?: { id?: string; name?: string } | string;
  note?: string;
};
