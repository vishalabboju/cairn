/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}", "./lib/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: {
          50: "#eff6f6",
          100: "#d7eaea",
          200: "#b0d5d5",
          300: "#7fb9ba",
          400: "#4d9699",
          500: "#2f7a7d",
          600: "#0f5257",
          700: "#0d4449",
          800: "#0c383c",
          900: "#0a2e31"
        },
        accent: { 400: "#e8a838", 500: "#dd9421", 600: "#c07f1a" },
        surface: "#f7f5f0"
      },
      fontFamily: { sans: ["Inter", "ui-sans-serif", "system-ui", "sans-serif"] }
    }
  },
  plugins: []
};
