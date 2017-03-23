import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
  'vue': '2.*',
  'vue-router': '2.*',
  'vue-meta': '*'
}, 'mrmasly:vue');
