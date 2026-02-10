import { createHmac, timingSafeEqual } from 'crypto';

const isPlainObject = (value: unknown): value is Record<string, unknown> => {
  return (
    !!value &&
    typeof value === 'object' &&
    !Array.isArray(value) &&
    Object.prototype.toString.call(value) === '[object Object]'
  );
};

const stableStringify = (value: unknown): string => {
  if (value === null || value === undefined) return 'null';
  if (typeof value === 'string') return JSON.stringify(value);
  if (typeof value === 'number' || typeof value === 'boolean') return JSON.stringify(value);
  if (Array.isArray(value)) {
    return `[${value.map((item) => stableStringify(item)).join(',')}]`;
  }
  if (isPlainObject(value)) {
    const keys = Object.keys(value).sort();
    const entries = keys.map((key) => `${JSON.stringify(key)}:${stableStringify(value[key])}`);
    return `{${entries.join(',')}}`;
  }
  return JSON.stringify(value);
};

export const resolveBodyString = (rawBody: string | undefined, body: unknown): string => {
  if (rawBody && rawBody.length > 0) return rawBody;
  return stableStringify(body ?? {});
};

export const signBody = (bodyString: string, secret: string): string => {
  return createHmac('sha256', secret).update(bodyString).digest('hex');
};

export const verifySignature = (
  bodyString: string,
  signature: string | undefined,
  secret: string,
): boolean => {
  if (!signature) return false;
  const expected = signBody(bodyString, secret);
  try {
    const a = Buffer.from(expected, 'hex');
    const b = Buffer.from(signature, 'hex');
    if (a.length !== b.length) return false;
    return timingSafeEqual(a, b);
  } catch {
    return false;
  }
};
