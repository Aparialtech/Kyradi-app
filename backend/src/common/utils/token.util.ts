import * as crypto from 'crypto';

interface TokenPayload {
  sub: string;
  email: string;
  exp: number;
}

const DEFAULT_TTL = 60 * 60 * 24; // 24h

export function generateToken(
  payload: Omit<TokenPayload, 'exp'>,
  secret: string,
  ttlSeconds: number = DEFAULT_TTL,
): string {
  const exp = Math.floor(Date.now() / 1000) + ttlSeconds;
  const tokenPayload: TokenPayload = { ...payload, exp };
  const encoded = Buffer.from(JSON.stringify(tokenPayload)).toString('base64url');
  const signature = crypto
    .createHmac('sha256', secret)
    .update(encoded)
    .digest('base64url');
  return `${encoded}.${signature}`;
}

export function verifyToken(token: string, secret: string): TokenPayload | null {
  const [encoded, signature] = token.split('.');
  if (!encoded || !signature) return null;
  const expectedSig = crypto
    .createHmac('sha256', secret)
    .update(encoded)
    .digest('base64url');
  if (!crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expectedSig))) {
    return null;
  }
  try {
    const payload = JSON.parse(Buffer.from(encoded, 'base64url').toString()) as TokenPayload;
    if (payload.exp < Math.floor(Date.now() / 1000)) {
      return null;
    }
    return payload;
  } catch {
    return null;
  }
}
