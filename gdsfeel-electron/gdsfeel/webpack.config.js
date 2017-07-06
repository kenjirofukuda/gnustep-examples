var path = require('path');

module.exports = {
  entry: [
    './src/geo.js',
    './src/gds.js',
    './src/gds-elements.js',
    './src/gds-container.js'
  ],
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  }
};
