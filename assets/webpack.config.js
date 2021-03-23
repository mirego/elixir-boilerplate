/* eslint-env node */
const path = require('path');
const glob = require('glob');

const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');

const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (_env, options) => {
  const devMode = options.mode !== 'production';

  return {
    optimization: {
      minimizer: [
        new TerserPlugin({cache: true, parallel: true}),
        new OptimizeCSSAssetsPlugin({})
      ]
    },
    entry: {
      './js/app.js': ['./js/app.js'].concat(glob.sync('./vendor/**/*.js'))
    },
    output: {
      filename: 'app.js',
      path: path.resolve(__dirname, '../priv/static/js')
    },
    devtool: devMode ? 'eval-cheap-module-source-map' : 'source-map',
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader'
          }
        },
        {
          test: /\.css$/,
          use: [MiniCssExtractPlugin.loader, 'css-loader']
        }
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({filename: '../css/app.css'}),
      new CopyWebpackPlugin({patterns: [{from: 'static/', to: '../'}]})
    ]
  };
};
