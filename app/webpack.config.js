const path = require('path');

module.exports = {
  mode: 'development',
  entry: './frontend/js/index.tsx',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'public/js')
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: 'ts-loader'
      },
    ],
  },
  resolve: {
    modules: [path.resolve(__dirname, 'frontend/js'), 'node_modules'],
    extensions: ['.ts', '.tsx', '.js', '.json']
  }
};