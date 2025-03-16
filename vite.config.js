import { defineConfig } from "vite";
import rubyPlugin from "vite-plugin-ruby";
import fullReload from "vite-plugin-full-reload";
import stimulusHMR from "vite-plugin-stimulus-hmr";
import legacy from "@vitejs/plugin-legacy";
import postcssPresetEnv from "postcss-preset-env";
import postcssFlexbugsFixes from "postcss-flexbugs-fixes";
import cssnano from "cssnano";
import tailwindcss from "tailwindcss";
import coffee from "vite-plugin-coffee";
import vitePluginCompression from "vite-plugin-compression";
import { constants } from "node:zlib";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  resolve: {
    extensions: [".js", ".coffee", ".scss"],
  },
  assetsInclude: ["**/*.jsdos", "**/*.gguf"],
  build: {
    sourcemap: true,
    cache: true,
    rollupOptions: {
      output: {
        entryFileNames: "[name]-[hash].js",
        chunkFileNames: "[name]-[hash].js",
        assetFileNames: "[name]-[hash].[ext]",
      },
    },
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
    vue(),
    coffee({
      jsx: false,
    }),
    stimulusHMR(),
    legacy({
      targets: ["defaults", "not IE 11"],
      additionalLegacyPolyfills: ["regenerator-runtime/runtime"],
      renderLegacyChunks: true,
      modernPolyfills: true,
    }),
    vitePluginCompression({
      algorithm: "brotliCompress",
      filter: /\.(js|css)$/i, // Specify which resources are not compressed
      disable: false, // Whether to disable compression
      compressionOptions: {
        params: {
          [constants.BROTLI_PARAM_QUALITY]: 11,
          [constants.BROTLI_PARAM_LGWIN]: 22,
          [constants.BROTLI_PARAM_LGBLOCK]: 0,
          [constants.BROTLI_PARAM_MODE]: constants.BROTLI_MODE_TEXT,
        },
      },
      threshold: 1500, // It will be compressed if the volume is larger than threshold (in bytes)
      ext: ".br", // Suffix of the generated compressed package
      deleteOriginFile: false,
    }),
    vitePluginCompression({
      algorithm: "gzip",
      filter: /\.(js|css)$/i,
      disable: false,
      compressionOptions: {
        level: 6,
      },
      threshold: 1500,
      ext: ".gz",
      deleteOriginFile: false,
    }),
  ],
});
