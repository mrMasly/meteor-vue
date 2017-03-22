import Vue from 'vue'

Meteor.startup ->
  div = document.createElement 'div'
  div.id = "vie-root"
  document.body.insertBefore div, document.body.childNodes[0]
  Meteor.vue = new Vue
    render: (h) -> h Meteor.rootComponent
  Meteor.vue.$mount '#vie-root'
