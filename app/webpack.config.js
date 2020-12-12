const path = require('path');

module.exports = {
  mode: 'development',
  entry: './frontend/ts/index.tsx',
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
    alias: { react: path.resolve('./node_modules/react') },
    modules: [path.resolve(__dirname, 'frontend/ts'), 'node_modules'],
    extensions: ['.ts', '.tsx', '.js', '.json']
  }
};