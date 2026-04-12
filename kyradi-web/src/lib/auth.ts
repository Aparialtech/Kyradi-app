const TOKEN_KEY = 'kyradi_web_token';
const USER_ID_KEY = 'kyradi_web_user_id';

export function getToken(): string | null {
  if (typeof window === 'undefined') return null;
  return window.localStorage.getItem(TOKEN_KEY);
}

export function setToken(token: string): void {
  if (typeof window === 'undefined') return;
  window.localStorage.setItem(TOKEN_KEY, token);
}

export function clearToken(): void {
  if (typeof window === 'undefined') return;
  window.localStorage.removeItem(TOKEN_KEY);
}

export function getUserId(): string | null {
  if (typeof window === 'undefined') return null;
  return window.localStorage.getItem(USER_ID_KEY);
}

export function setUserId(userId: string): void {
  if (typeof window === 'undefined') return;
  window.localStorage.setItem(USER_ID_KEY, userId);
}

export function clearUserId(): void {
  if (typeof window === 'undefined') return;
  window.localStorage.removeItem(USER_ID_KEY);
}

export function clearSession(): void {
  clearToken();
  clearUserId();
}
