'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { getToken } from '@/lib/auth';
import type { PropsWithChildren } from 'react';

export function ProtectedPage({ children }: PropsWithChildren) {
  const router = useRouter();
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const token = getToken();
    if (!token) {
      router.replace('/login');
      return;
    }
    setReady(true);
  }, [router]);

  if (!ready) {
    return <div className="page">Yükleniyor...</div>;
  }

  return <>{children}</>;
}
