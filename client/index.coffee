import Vue from 'vue'
import VueRouter from 'vue-router'

Meteor.startup ->
  router = new VueRouter
    routes: getRoutes()
    mode: 'history'
  div = document.createElement 'div'
  div.id = "vie-root"
  document.body.insertBefore div, document.body.childNodes[0]
  Meteor.vue = new Vue
    router: router
    render: (h) -> h Meteor.rootComponent
  Meteor.vue.$mount '#vie-root'


getRoutes = ->
  routes = []
  Module = module.parent
  for id, mod of Module.childrenById
    continue if id.indexOf('.vue') is -1
    component = mod.exports.default
    continue unless component.route?
    route = component.route
    route.component = component
    routes.push route
  return routes
