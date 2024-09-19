module.exports = {
  plugins: [
    require('postcss-import')({
      extensions: ['.css','.scss']
    }),
    require("@csstools/postcss-sass")({
    }),
    require("tailwindcss"),
    require("postcss-preset-env")({
      stage: 3,
      features: {
        "custom-properties": false,
      },
    }),
    require("cssgrace"),
    require("postcss-flexbugs-fixes"),
    require("cssnano")({
      preset: [
        "default",
        {
          discardComments: { removeAll: true },
        },
      ],
    }),
  ],
};
