module.exports = {
  plugins: [
    require("postcss-import")({
      extensions: [".css", ".scss"],
    }),
    require("@csstools/postcss-sass"),
    require("tailwindcss"),
    require("postcss-inline-rtl"),
    require("postcss-preset-env")({
      stage: 0,
      features: {
        "custom-properties": false,
      },
    }),
    require("cssgrace"),
    require("postcss-flexbugs-fixes"),
    require("cssnano")({
      preset: [
        "advanced",
        {
          autoprefixer: false,
          discardComments: { removeAll: true },
          mergeLonghand: true,
          calc: { precision: 2 },
          colormin: true,
          zindex: true,
          normalizeString: true,
          normalizeUrl: true,
          normalizeCharset: true,
          mergeRules: true,
          discardUnused: { fontFace: true, keyframes: true },
          svgo: {
            plugins: [
              { removeViewBox: false },
              { removeDimensions: true },
            ],
          },
          convertValues: { length: true },
        },
      ],
    }),
  ],
};
