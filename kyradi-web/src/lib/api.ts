import { getToken } from '@/lib/auth';
import type {
  ApiUser,
  LocationItem,
  LoginResponse,
  LuggageCreatePayload,
  LuggageItem,
  LuggageStatus,
  PaymentMethod,
  ReservationChangePayload,
  WalletOverview,
  WalletTx,
} from '@/lib/types';

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL ??
  'https://kyradi-app-production.up.railway.app';

type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';

function parseJsonSafely<T>(text: string): T | Record<string, unknown> {
  if (!text) return {};
  try {
    return JSON.parse(text) as T;
  } catch {
    return {};
  }
}

function toErrorMessage(payload: unknown, status: number, statusText: string): string {
  if (payload && typeof payload === 'object') {
    const data = payload as Record<string, unknown>;
    const message = data.message ?? data.error;
    if (typeof message === 'string') return message;
    if (Array.isArray(message)) return message.join(', ');
  }
  return `HTTP_${status}_${statusText}`;
}

async function request<T>(
  path: string,
  method: HttpMethod = 'GET',
  body?: unknown,
  token?: string,
): Promise<T> {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
  };

  const sessionToken = token ?? getToken();
  if (sessionToken) {
    headers.Authorization = `Bearer ${sessionToken}`;
  }

  const res = await fetch(`${API_BASE_URL}${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
    cache: 'no-store',
  });

  const text = await res.text();
  const parsed = parseJsonSafely<T>(text);

  if (!res.ok) {
    throw new Error(toErrorMessage(parsed, res.status, res.statusText));
  }

  return parsed as T;
}

function normalizeList<T>(payload: unknown, keys: string[]): T[] {
  if (Array.isArray(payload)) return payload as T[];
  if (payload && typeof payload === 'object') {
    const data = payload as Record<string, unknown>;
    for (const key of keys) {
      if (Array.isArray(data[key])) {
        return data[key] as T[];
      }
    }
  }
  return [];
}

function toIsoString(value?: string | Date | null): string | undefined {
  if (!value) return undefined;
  if (value instanceof Date) return value.toISOString();
  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) return undefined;
  return parsed.toISOString();
}

function compact<T extends Record<string, unknown>>(payload: T): T {
  const cloned = { ...payload };
  Object.keys(cloned).forEach((key) => {
    const value = cloned[key];
    if (value === undefined || value === null || value === '') {
      delete cloned[key];
    }
  });
  return cloned;
}

function parseLuggagePayload(payload: unknown): LuggageItem {
  if (!payload || typeof payload !== 'object') return {};
  return payload as LuggageItem;
}

export function getApiBaseUrl(): string {
  return API_BASE_URL;
}

export async function login(email: string, password: string): Promise<LoginResponse> {
  return request<LoginResponse>('/auth/login', 'POST', { email, password });
}

export async function register(payload: {
  name: string;
  surname: string;
  email: string;
  password: string;
  phone?: string;
  nationalId?: string;
}): Promise<Record<string, unknown>> {
  return request('/auth/register', 'POST', payload);
}

export async function verifyEmailCode(email: string, code: string): Promise<Record<string, unknown>> {
  return request('/auth/verify', 'POST', { email, code });
}

export async function resendEmailVerifyCode(email: string): Promise<Record<string, unknown>> {
  return request('/auth/resend-verify', 'POST', { email });
}

export async function fetchMe(): Promise<ApiUser> {
  return request<ApiUser>('/me');
}

export async function updateProfile(userId: string, payload: Record<string, unknown>) {
  return request(`/users/${userId}`, 'PUT', payload);
}

export async function updateMyProfile(payload: Record<string, unknown>) {
  return request('/me/profile', 'PUT', payload);
}

export async function fetchLocations(): Promise<LocationItem[]> {
  const result = await request<unknown>('/locations');
  return normalizeList<LocationItem>(result, ['locations', 'data']);
}

export async function estimatePricing(payload: {
  sizeClass: 'small' | 'medium' | 'large';
  dropAt: string;
  pickupAt: string;
  protectionLevel?: 'standard' | 'premium';
  paymentMethod?: PaymentMethod;
}): Promise<Record<string, unknown>> {
  return request('/pricing/estimate', 'POST', payload);
}

export async function fetchLuggages(userId: string): Promise<LuggageItem[]> {
  const result = await request<unknown>(`/users/${userId}/luggages`);
  return normalizeList<LuggageItem>(result, ['luggages', 'data']);
}

export async function createLuggage(
  userId: string,
  payload: LuggageCreatePayload,
): Promise<LuggageItem> {
  const body = compact({
    ...payload,
    scheduledDropTime: toIsoString(payload.scheduledDropTime),
    scheduledPickupTime: toIsoString(payload.scheduledPickupTime),
  });
  const result = await request<unknown>(`/users/${userId}/luggages`, 'POST', body);
  if (result && typeof result === 'object') {
    const data = result as Record<string, unknown>;
    if (data.luggage && typeof data.luggage === 'object') {
      return parseLuggagePayload(data.luggage);
    }
  }
  return parseLuggagePayload(result);
}

export async function updateLuggageMetadata(
  userId: string,
  luggageId: string,
  payload: ReservationChangePayload,
): Promise<Record<string, unknown>> {
  return request(`/users/${userId}/luggages/${luggageId}`, 'PUT', compact({
    ...payload,
    scheduledDropTime: toIsoString(payload.scheduledDropTime),
    scheduledPickupTime: toIsoString(payload.scheduledPickupTime),
  }));
}

export async function requestLuggageMetadataChange(
  userId: string,
  luggageId: string,
  payload: ReservationChangePayload,
): Promise<Record<string, unknown>> {
  return request(`/users/${userId}/luggages/${luggageId}/change-request`, 'POST', compact({
    ...payload,
    scheduledDropTime: toIsoString(payload.scheduledDropTime),
    scheduledPickupTime: toIsoString(payload.scheduledPickupTime),
  }));
}

export async function confirmLuggageMetadataChange(
  userId: string,
  luggageId: string,
  code: string,
): Promise<Record<string, unknown>> {
  return request(`/users/${userId}/luggages/${luggageId}/change-confirm`, 'POST', { code });
}

export async function updateLuggageStatus(
  userId: string,
  luggageId: string,
  status: LuggageStatus,
  options?: {
    pickupPin?: string;
    delegateCode?: string;
  },
): Promise<Record<string, unknown>> {
  return request(`/users/${userId}/luggages/${luggageId}/status`, 'PUT', compact({
    status,
    pickupPin: options?.pickupPin,
    delegateCode: options?.delegateCode,
  }));
}

export async function cancelLuggage(
  userId: string,
  luggageId: string,
): Promise<Record<string, unknown>> {
  return request(`/users/${userId}/luggages/${luggageId}/cancel`, 'POST');
}

export async function startPaymentCheckout(payload: {
  reservationId: string;
  paymentMethod: Exclude<PaymentMethod, 'wallet'>;
  installmentCount?: number;
}): Promise<Record<string, unknown>> {
  return request('/payments/checkout', 'POST', payload);
}

export async function fetchPaymentStatus(reservationId: string): Promise<Record<string, unknown>> {
  const encoded = encodeURIComponent(reservationId.trim());
  return request(`/payments/status?reservationId=${encoded}`, 'GET');
}

export async function walletPay(payload: {
  reservationId: string;
  amount?: number;
}): Promise<Record<string, unknown>> {
  return request('/wallet/pay', 'POST', compact(payload));
}

export async function walletTopup(payload: { amount: number }): Promise<Record<string, unknown>> {
  return request('/wallet/topup', 'POST', payload);
}

export async function fetchWallet(): Promise<WalletOverview> {
  const result = await request<unknown>('/wallet');
  if (!result || typeof result !== 'object') {
    return { balance: 0, transactions: [] };
  }
  const data = result as Record<string, unknown>;
  return {
    balance: Number(data.balance ?? 0),
    transactions: Array.isArray(data.transactions)
      ? (data.transactions as WalletOverview['transactions'])
      : [],
  };
}

export async function fetchWalletTransactions(): Promise<WalletTx[]> {
  const result = await request<unknown>('/wallet/transactions');
  return normalizeList<WalletTx>(result, ['transactions', 'data']);
}
