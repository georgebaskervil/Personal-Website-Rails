import { defineConfig } from "vite";
import rubyPlugin from "vite-plugin-ruby";
import fullReload from "vite-plugin-full-reload";
import stimulusHMR from "vite-plugin-stimulus-hmr";
import legacy from "vite-plugin-legacy-swc";
import postcssPresetEnv from "postcss-preset-env";
import postcssFlexbugsFixes from "postcss-flexbugs-fixes";
import cssnano from "cssnano";
import tailwindcss from "tailwindcss";
import coffee from "vite-plugin-coffee";

export default defineConfig({
  resolve: {
    extensions: [".js", ".coffee", ".scss"],
  },
  assetsInclude: ["**/*.jsdos"],
  build: {
    sourcemap: false,
  },
  server: {
    hmr: { overlay: false },
  },
  css: {
    preprocessorOptions: {
      scss: {
        api: "modern-compiler",
      },
    },
    postcss: {
      plugins: [
        tailwindcss(),
        postcssPresetEnv({ stage: 3 }),
        postcssFlexbugsFixes(),
        cssnano({
          preset: [
            "advanced",
            {
              autoprefixer: false,
              discardComments: { removeAllButCopyright: true },
              normalizeString: true,
              normalizeUrl: true,
              normalizeCharset: true,
            },
          ],
        }),
      ],
    },
  },
  plugins: [
    rubyPlugin(),
    fullReload(["config/routes.rb", "app/views/**/*"]),
    coffee({
      jsx: false,
    }),
    stimulusHMR(),
    legacy({
      terserOptions: {
        ecma: 5,
        warnings: true,
        mangle: {
          properties: false,
          safari10: true,
          toplevel: false,
        },
        compress: {
          defaults: true,
          arrows: false,
          booleans_as_integers: false,
          booleans: true,
          collapse_vars: true,
          comparisons: true,
          conditionals: true,
          dead_code: true,
          drop_console: true,
          directives: true,
          evaluate: true,
          hoist_funs: true,
          if_return: true,
          join_vars: true,
          keep_fargs: false,
          loops: true,
          negate_iife: true,
          passes: 3,
          properties: true,
          reduce_vars: true,
          sequences: true,
          side_effects: true,
          toplevel: false,
          typeofs: false,
          unused: true,
        },
        output: {
          comments: /(?:copyright|licence|©)/i,
          beautify: false,
          semicolons: true,
        },
        keep_classnames: false,
        keep_fnames: false,
        safari10: true,
        module: true,
      },
    }),
  ],
});
