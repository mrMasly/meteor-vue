import Vue from 'vue'

Meteor.startup ->

  $('body').prepend '<app></app>'
  Meteor.vue = new Vue
    render: (h) -> h Meteor.rootComponent
  Meteor.vue.$mount 'app'
