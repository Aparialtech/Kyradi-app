import * as crypto from 'crypto';

const SALT_LENGTH = 16;

export function hashPassword(raw: string): string {
  const salt = crypto.randomBytes(SALT_LENGTH).toString('hex');
  const hash = crypto.pbkdf2Sync(raw, salt, 10000, 64, 'sha512').toString('hex');
  return `${salt}:${hash}`;
}

export function verifyPassword(raw: string, hashed: string): boolean {
  const [salt, hash] = hashed.split(':');
  if (!salt || !hash) return false;
  const candidate = crypto.pbkdf2Sync(raw, salt, 10000, 64, 'sha512').toString('hex');
  return crypto.timingSafeEqual(Buffer.from(hash, 'hex'), Buffer.from(candidate, 'hex'));
}
