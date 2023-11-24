  /** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
    colors: {
      'light': '#F04D4D',
      'semi-light': '#D14343',
      'semi-dark': '#555555',
      'dark': '#191919',
    },
  },
  plugins: [
    require('tailwind-scrollbar'),
  ],
}

