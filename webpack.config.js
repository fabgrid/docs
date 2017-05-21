module.exports = {
  entry: "./webpack/entry.ts",

  output: {
      path: 'src/assets/js/',
      filename: "bundle.js"
  },

  resolve: {
    extensions: ['', '.webpack.js', '.web.js', '.ts', '.js', '.vue', '.lang.json'],
    alias: {
      'vue$': 'vue/dist/vue.common.js'
    }
  },

  module: {
    loaders: [
      { test: /\.ts$/, loader: 'vue-ts' },
      { test: /\.vue$/, loader: "vue" },
      { test: /\.lang\.json$/, loader: "langmerge" },
    ]
  },

  vue: {
    loaders: { js: 'vue-ts-loader' },
    esModule: true,
  }
};
