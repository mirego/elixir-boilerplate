/* eslint-env node */
const path = require('path');
const glob = require('glob');

const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CopyPlugin = require('copy-webpack-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');

module.exports = (_env, options) => {
  const devMode = options.mode !== 'production';

  return {
    entry: {
      app: glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
    },
    output: {
      path: path.resolve(__dirname, '../priv/static/js'),
      filename: '[name].js',
      publicPath: '/js/'
    },
    resolve: {
      modules: ['node_modules']
    },
    module: {
      rules: [
        {
          test: /\.css$/,
          use: [MiniCssExtractPlugin.loader, 'css-loader']
        }
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({filename: '../css/app.css'}),
      new CopyPlugin({patterns: [{from: 'static/', to: '../'}]})
    ],
    optimization: {
      minimizer: [new CssMinimizerPlugin()]
    },
    devtool: devMode ? 'source-map' : undefined
  };
};
