import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'KYRADI Web',
  description: 'KYRADI SuperApp web istemcisi',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="tr">
      <body>{children}</body>
    </html>
  );
}
