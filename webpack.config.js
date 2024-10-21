const path = require("path");
const webpack = require("webpack");
const TerserPlugin = require("terser-webpack-plugin");

module.exports = {
  mode: "production",
  entry: {
    application: "./app/javascript/application.js",
  },
  output: {
    filename: "[name].js",
    chunkFormat: "module",
    path: path.resolve(__dirname, "app/assets/builds"),
    publicPath: "/assets/",
  },
  module: {
    rules: [
      {
        // JavaScript rule using Babel
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            configFile: path.resolve(__dirname, "babel.config.js"),
          },
        },
      },
      {
        // CoffeeScript rule
        test: /\.coffee$/,
        exclude: /node_modules/,
        use: [
          {
            loader: "babel-loader", // First, compile CoffeeScript to ES6
            options: {
              configFile: path.resolve(__dirname, "babel.config.js"),
            },
          },
          {
            loader: "coffee-loader", // Then, convert CoffeeScript to JavaScript
          },
        ],
      },
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
    extensions: [".js", ".coffee"], // Tell Webpack to resolve .coffee files
  },
};
