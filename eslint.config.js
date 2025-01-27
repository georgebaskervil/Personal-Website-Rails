import unicorn from "eslint-plugin-unicorn";
import globals from "globals";
import path from "node:path";
import { fileURLToPath } from "node:url";
import js from "@eslint/js";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
  baseDirectory: __dirname,
  recommendedConfig: js.configs.recommended,
  allConfig: js.configs.all,
});

export default [
  {
    ignores: [
      "app//builds**",
      "**/node_modules/",
      "**/vendor/",
      "**/tmp/",
      "**.config.js",
      "public/**",
      "app//libs/**",
    ],
  },
  ...compat.extends(
    "eslint:recommended",
    "plugin:unicorn/recommended",
    "prettier",
  ),
  {
    plugins: {
      unicorn,
    },

    languageOptions: {
      globals: {
        ...globals.browser,
      },

      ecmaVersion: "latest",
      sourceType: "module",
    },

    // Add rules section
    rules: {
      "unicorn/filename-case": "off",
      "unicorn/no-anonymous-default-export": "off",
      "unicorn/no-empty-file": "off",
    },
  },
];
