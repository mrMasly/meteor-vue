Package.describe({
  name: 'mrmasly:vue',
  version: '0.1.0',
  summary: 'Akryum:vue-meteor all in one',
  git: 'https://github.com/mrMasly/meteor-vue',
  documentation: 'README.md'
});

Package.registerBuildPlugin({
  name: "vue-component",
  use: [
    'ecmascript@0.6.3',
    'caching-compiler@1.1.9',
    'babel-compiler@6.13.0',
  ],
  sources: [
    'build/vue-component/regexps.js',
    'build/vue-component/utils.js',
    'build/vue-component/dev-server.js',
    'build/vue-component/post-css.js',
    'build/vue-component/tag-scanner.js',
    'build/vue-component/tag-handler.js',
    'build/vue-component/vue-compiler.js',
    'build/vue-component/plugin.js'
  ],
  npmDependencies: {
    'postcss': '5.2.15',
    'postcss-selector-parser': '2.2.3',
    'postcss-modules': '0.6.4',
    'socket.io': '1.7.3',
    'async': '2.1.5',
    'lodash': '4.17.4',
    'hash-sum': '1.0.2',
    'source-map': '0.5.6',
    'source-map-merger': '0.2.0',
    'generate-source-map': '0.0.5',
    'autoprefixer': '6.7.5',
    'vue-template-compiler': '2.2.4',
    'vue-template-es2015-compiler': '1.5.1',
  }
});


Package.registerBuildPlugin({
  name: "vue-component-stylus",
  use: [ 'ecmascript@0.6.3' ],
  sources: [ 'build/vue-stylus.js' ],
  npmDependencies: {
    stylus: "0.54.5",
    nib: "1.1.2"
  }
});

Package.registerBuildPlugin({
  name: "vue-component-coffee",
  use: [ 'ecmascript@0.6.3' ],
  sources: [ 'build/vue-coffee.js' ],
  npmDependencies: {
    'coffee-script': '1.12.4',
    'source-map': '0.5.6'
  }
});

Package.registerBuildPlugin({
  name: "vue-component-jade",
  use: [ 'ecmascript@0.6.3' ],
  sources: [ 'build/vue-jade.js' ],
  npmDependencies: {
    'jade': '1.11.0'
  }
});


Npm.depends({
  'lodash.omit': '4.5.0',
  'lodash.union': '4.6.0',
  'lodash.sortby': '4.7.0'
});


Package.onUse(function(api) {
  api.versionsFrom('1.4.3.2');
  api.use('ecmascript@0.6.3');
  api.use('coffeescript@1.12.3_1');
  api.use('akryum:npm-check@0.0.2');
  api.use('isobuild:compiler-plugin@1.0.0');
  api.use('akryum:vue-component-dev-server@0.0.5');
  api.use('akryum:vue-component-dev-client@0.2.8');

  api.use('akryum:vue-ssr@0.1.0');

  api.addFiles([
    'common/modules.coffee',
    'common/startup.coffee',
    'plugins/subscribe.js',
    'plugins/call.coffee',
    'plugins/router.coffee'
  ], ['client', 'server']);

  api.addFiles([
    'server/index.coffee',
    'server/methods.coffee',
    'server/publish.coffee'
  ], 'server');

});
