Package.describe({
  name: 'mrmasly:vue-hot',
  version: '0.0.1',
  summary: 'Akryum:vue-meteor all in one',
  git: 'https://github.com/mrMasly/meteor-vue',
  documentation: 'README.md',
  debugOnly: true
});

Npm.depends({
  'socket.io-client': '1.4.6'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4.3.2');
  api.use('ecmascript@0.6.3');
  api.use('reload@1.1.11');
  api.use('autoupdate@1.3.12');
  api.use('reactive-var@1.0.11');
  api.use('webapp@1.3.16');
  api.mainModule('client/index.js', 'client');
  api.mainModule('server/index.js', 'server');
});