const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        // Our custom futuristic dark theme colors
        primary: {
          DEFAULT: '#0891b2', // cyan-600
          hover: '#06b6d4',   // cyan-500
        },
        secondary: {
          DEFAULT: '#6366f1', // indigo-500
          hover: '#818cf8',   // indigo-400
        },
        accent: {
          DEFAULT: '#a855f7', // purple-500
          hover: '#c084fc',   // purple-400
        },
        success: {
          DEFAULT: '#10b981', // emerald-500
          hover: '#34d399',   // emerald-400
        },
        warning: {
          DEFAULT: '#f43f5e', // rose-500
          hover: '#fb7185',   // rose-400
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
