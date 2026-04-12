import type { Config } from 'tailwindcss';

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        kyradiBg: '#0B0F1A',
        kyradiPrimary: '#6366F1',
        kyradiAccent: '#22D3EE',
      },
      boxShadow: {
        glow: '0 0 35px rgba(34,211,238,0.25)',
      },
    },
  },
  plugins: [],
};

export default config;
