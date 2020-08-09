const path = require('path');
const webpack = require('webpack')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const WebpackManifestPlugin = require('webpack-manifest-plugin')

module.exports = {
  entry: path.resolve(__dirname, 'node_modules', 'digital-terrain-mc-js', 'lib', 'registration.js'),
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, '..', 'app', 'assets', 'javascripts'),
    publicPath: '/assets/',
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name]-[chunkhash].css',
    }),
    new WebpackManifestPlugin({
      fileName: 'webpack-manifest.json',
      publicPath: '/assets/',
    }),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(process.env.NODE_ENV)
      }
    }),
  ],

  resolve:{
    alias:{
      'react-on-rails': path.resolve(__dirname, 'node_modules', 'react-on-rails')
    }
  },
  module: {
    rules: [
      {
        test: /\.(png|svg|jpg|jpeg|gif|ico)$/,
        use: [
          'file-loader?name=[name].[ext]',
        ],
      },
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader'],
      },
    ]
  }
};
