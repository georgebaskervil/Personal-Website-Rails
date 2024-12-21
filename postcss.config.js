module.exports = {
  plugins: [
    require("postcss-import")({
      extensions: [".css", ".scss"],
    }),
    require("@csstools/postcss-sass"),
    require("tailwindcss"),
    require("postcss-preset-env")({
      stage: 0,
      features: {
        "custom-properties": false,
      },
    }),
    require("postcss-flexbugs-fixes"),
    require("cssnano")({
      preset: [
        "default",
        {
          autoprefixer: false,
          discardComments: { removeAllButCopyright: true },
          mergeLonghand: false,
          calc: { precision: 2 },
          colormin: true,
          zindex: true,
          normalizeString: false,
          normalizeUrl: false,
          normalizeCharset: false,
          mergeRules: false,
          discardUnused: { fontFace: false, keyframes: false },
          svgo: {
            plugins: [{ removeViewBox: false }, { removeDimensions: false }],
          },
          convertValues: { length: true },
        },
      ],
    }),
  ],
};
