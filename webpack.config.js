const path = require("node:path");
const webpack = require("webpack");
const TerserPlugin = require("terser-webpack-plugin");

module.exports = {
  mode: "production",
  entry: {
    application: "./app/javascript/application.js",
  },
  output: {
    filename: "[name].js",
    library: {
      type: "umd", // Change to UMD for browser compatibility
    },
    path: path.resolve(__dirname, "app/assets/builds"),
    publicPath: "/assets/",
  },
  module: {
    rules: [
      {
        test: /\.m?jsx?$/,
        include: [
          path.resolve(__dirname, "app/javascript"),
          path.resolve(__dirname, "app/assets"),
        ],
        exclude: /node_modules\/core-js/,
        use: {
          loader: "babel-loader",
          options: {
            configFile: path.resolve(__dirname, "babel.config.js"),
            sourceType: "module",
          },
        },
      },
      {
        // CoffeeScript rule
        test: /\.coffee$/,
        use: [
          {
            loader: "babel-loader", // First, compile CoffeeScript to ES6
            options: {
              configFile: path.resolve(__dirname, "babel.config.js"),
              sourceType: "module", // Handle ES modules
            },
          },
          {
            loader: "coffee-loader", // Then, convert CoffeeScript to JavaScript
          },
        ],
      },
      // ...other rules...
    ],
  },
  optimization: {
    minimize: true,
    minimizer: [
      new TerserPlugin({
        terserOptions: require("./terser.config.js"),
      }),
    ],
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1,
    }),
  ],
  resolve: {
    extensions: [".js", ".coffee"], // Ensure Webpack resolves .coffee files
  },
};
