import type { ReactNode } from 'react';

type StatusBadgeProps = {
  value?: string | null;
  children?: ReactNode;
};

function resolveClass(value?: string | null) {
  const v = (value ?? '').toLowerCase();
  if (v.includes('paid') || v.includes('verified') || v.includes('picked') || v.includes('active')) {
    return 'badge ok';
  }
  if (v.includes('failed') || v.includes('cancel') || v.includes('reject')) {
    return 'badge err';
  }
  return 'badge warn';
}

export function StatusBadge({ value, children }: StatusBadgeProps) {
  return <span className={resolveClass(value)}>{children ?? value ?? '-'}</span>;
}
