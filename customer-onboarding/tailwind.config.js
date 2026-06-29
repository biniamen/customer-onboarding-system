/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{html,ts}'],
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#fff9eb',
          100: '#fff1c4',
          200: '#ffe58a',
          300: '#f8d04d',
          400: '#ebab23',
          500: '#d79412',
          600: '#bb7a0d',
          700: '#955b10',
          800: '#7a4913',
          900: '#663d14'
        },
        accent: {
          50: '#edf8f1',
          100: '#d5efdc',
          200: '#afdebf',
          300: '#7ec797',
          400: '#4da76e',
          500: '#228449',
          600: '#07522a',
          700: '#084424',
          800: '#0a351e',
          900: '#072616'
        }
      },
      boxShadow: {
        panel: '0 30px 80px rgba(7, 82, 42, 0.14)',
        glow: '0 18px 40px rgba(235, 171, 35, 0.22)'
      },
      fontFamily: {
        sans: ['Inter', 'Segoe UI', 'sans-serif']
      }
    }
  },
  plugins: []
};
