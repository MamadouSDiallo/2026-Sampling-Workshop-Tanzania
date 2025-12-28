// tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./course/**/*.{qmd,md}", // source content only
    "!./course/.quarto/**/*", // exclude Quarto temp/freeze
    "!./course_site/**/*",
    "!./node_modules/**/*",
    "!./.venv/**/*",
    "!./venv/**/*",
  ],
  theme: {
    extend: {
      colors: {
        svy: {
          50: "#f0f9ff",
          100: "#e0f2fe",
          200: "#bae6fd",
          300: "#7dd3fc",
          400: "#38bdf8",
          500: "#0ea5e9",
          600: "#0284c7",
          700: "#0369a1",
          800: "#075985",
          900: "#0c4a6e",
        },
      },
      maxWidth: { doc: "61rem" },
    },
  },
  corePlugins: {
    // Disable Preflight so it doesn't clobber Quarto's sidebar styles
    preflight: false,
  },
  plugins: [],
};
