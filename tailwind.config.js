module.exports = {
  content: [
    "./app/assets/stylesheets/**/*.scss",
    "./app/views/**/*.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/components/**/*.html.erb",
  ],
  theme: {
    extend: {
      colors: {
        neutral: "#2D2A2A",
        text: "#c0caf5",
        accent: "#ee7d82",
        comet: "#5d6177",
      },
    },
  },
};
