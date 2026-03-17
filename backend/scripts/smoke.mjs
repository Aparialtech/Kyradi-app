#!/usr/bin/env node

const baseUrl = (process.env.SMOKE_BASE_URL || 'http://127.0.0.1:3000').replace(/\/+$/, '');
const skipReservation = (process.env.SMOKE_SKIP_RESERVATION || '').toLowerCase() === 'true';
const timeoutMs = Number(process.env.SMOKE_TIMEOUT_MS || 15000);
const providedToken = (process.env.SMOKE_AUTH_TOKEN || '').trim();
const loginEmail = (process.env.SMOKE_LOGIN_EMAIL || '').trim().toLowerCase();
const loginPassword = process.env.SMOKE_LOGIN_PASSWORD || '';

const randomSuffix = `${Date.now()}${Math.floor(Math.random() * 100000)}`;
const email = `smoke_${randomSuffix}@example.com`;
const password = 'SmokePass123!';

async function request(path, options = {}) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  const headers = { ...(options.headers || {}) };
  if (options.body && !headers['Content-Type']) {
    headers['Content-Type'] = 'application/json';
  }
  try {
    const response = await fetch(`${baseUrl}${path}`, {
      ...options,
      headers,
      signal: controller.signal,
    });
    const raw = await response.text();
    let body = null;
    try {
      body = raw ? JSON.parse(raw) : null;
    } catch {
      body = raw || null;
    }
    return { status: response.status, body };
  } finally {
    clearTimeout(timer);
  }
}

function parseMessage(body) {
  if (!body) return '';
  if (typeof body === 'string') return body;
  if (Array.isArray(body.message)) return body.message.join(', ');
  if (typeof body.message === 'string') return body.message;
  if (typeof body.errorCode === 'string') return body.errorCode;
  return '';
}

function ensure(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

async function main() {
  console.log(`[SMOKE] baseUrl=${baseUrl}`);

  const version = await request('/__version');
  ensure(version.status === 200, `GET /__version failed: ${version.status}`);
  console.log('[SMOKE] ok: __version');

  let token = providedToken;
  if (token) {
    console.log('[SMOKE] ok: auth/token (env)');
  } else if (loginEmail && loginPassword) {
    const login = await request('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email: loginEmail, password: loginPassword }),
    });
    ensure(
      login.status === 200,
      `POST /auth/login failed: ${login.status} ${parseMessage(login.body)}`,
    );
    token = login.body?.accessToken ?? '';
    ensure(typeof token === 'string' && token.length > 20, 'Login token missing');
    console.log('[SMOKE] ok: auth/login (env user)');
  } else {
    const register = await request('/auth/register', {
      method: 'POST',
      body: JSON.stringify({
        email,
        password,
        name: 'Smoke',
        surname: 'User',
      }),
    });
    ensure(
      register.status === 200 || register.status === 201,
      `POST /auth/register failed: ${register.status} ${parseMessage(register.body)}`,
    );
    console.log('[SMOKE] ok: auth/register');

    const login = await request('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
    const loginMessage = parseMessage(login.body);
    if (
      login.status === 403 &&
      loginMessage.toLowerCase().includes('doğrulaman gerekiyor')
    ) {
      throw new Error(
        'Smoke kullanıcı doğrulama bekliyor. Prod için SMOKE_LOGIN_EMAIL/SMOKE_LOGIN_PASSWORD veya SMOKE_AUTH_TOKEN kullan.',
      );
    }
    ensure(
      login.status === 200,
      `POST /auth/login failed: ${login.status} ${loginMessage}`,
    );
    token = login.body?.accessToken ?? '';
    ensure(typeof token === 'string' && token.length > 20, 'Login token missing');
    console.log('[SMOKE] ok: auth/login');
  }

  const me = await request('/me', {
    headers: { Authorization: `Bearer ${token}` },
  });
  ensure(me.status === 200, `GET /me failed: ${me.status} ${parseMessage(me.body)}`);
  console.log('[SMOKE] ok: me');

  const wallet = await request('/wallet', {
    headers: { Authorization: `Bearer ${token}` },
  });
  ensure(wallet.status === 200, `GET /wallet failed: ${wallet.status} ${parseMessage(wallet.body)}`);
  console.log('[SMOKE] ok: wallet');

  const locations = await request('/locations', {
    headers: { Authorization: `Bearer ${token}` },
  });
  ensure(
    locations.status === 200,
    `GET /locations failed: ${locations.status} ${parseMessage(locations.body)}`,
  );
  const locationList = Array.isArray(locations.body)
    ? locations.body
    : Array.isArray(locations.body?.items)
      ? locations.body.items
      : [];
  console.log(`[SMOKE] ok: locations (${locationList.length})`);

  if (!skipReservation && locationList.length > 0) {
    const first = locationList[0] || {};
    const dropLocationId = first._id || first.id || '';
    const dropLocationName = first.name || first.address || '';
    if (dropLocationId && dropLocationName) {
      const reservation = await request('/reservations', {
        method: 'POST',
        headers: { Authorization: `Bearer ${token}` },
        body: JSON.stringify({
          dropLocationId,
          dropLocationName,
          label: 'Smoke Reservation',
        }),
      });
      if (reservation.status === 200 || reservation.status === 201) {
        console.log('[SMOKE] ok: reservations/create');
      } else {
        const msg = parseMessage(reservation.body);
        const softErrors = ['LOCATION_CLOSED', 'LOCATION_FULL', 'LOCATION_INACTIVE'];
        if (softErrors.includes(msg)) {
          console.log(`[SMOKE] warn: reservations/create skipped (${msg})`);
        } else {
          throw new Error(
            `POST /reservations failed: ${reservation.status} ${parseMessage(reservation.body)}`,
          );
        }
      }
    } else {
      console.log('[SMOKE] warn: reservation skipped (location fields missing)');
    }
  } else if (!skipReservation) {
    console.log('[SMOKE] warn: reservation skipped (no locations)');
  }

  console.log('[SMOKE] PASS');
}

main().catch((error) => {
  console.error('[SMOKE] FAIL:', error?.message || error);
  process.exitCode = 1;
});
