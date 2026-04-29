import type { Config } from 'tailwindcss'

export default {
  content: ['./index.html', './src/**/*.{vue,ts}'],
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: '#0f8f85',
          dark: '#08766e',
          soft: '#e3f5f2',
        },
        boy: '#2879d8',
        girl: '#ec675f',
        ink: '#172321',
        muted: '#687875',
        line: '#dde7e5',
        appbg: '#f4f7f6',
      },
      boxShadow: {
        card: '0 8px 22px rgba(24, 42, 39, 0.055)',
        hero: '0 16px 30px rgba(15, 143, 133, 0.22)',
      },
    },
  },
  plugins: [],
} satisfies Config
