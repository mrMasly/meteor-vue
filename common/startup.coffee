import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use VueRouter

if Meteor.isClient
  __meteor_runtime_config__.VUE_DEV_SERVER_URL = location.hostname+':'+(Number(location.port)+3)

createApp = ->

  { routes, root } = mapModules()

  router = new VueRouter
    routes: routes
    mode: 'history'

  app: new Vue
    el: '#app'
    router: router
    render: (h) -> h root
  router: router


Meteor.startup ->
  if Meteor.isServer
    VueSSR.template = '<div id="app"><!--vue-ssr-outlet--></div>'
    VueSSR.createApp = (url) ->
      { app, router } = createApp()
      router.push path: url.url
      return app

  else
    createApp()


mapModules = ->
  routes = []
  root
  Module = module.parent
  for id, mod of Module.childrenById
    continue if id.indexOf('.vue') is -1
    component = mod.exports.default
    root = component if component.root?
    continue unless component.route?
    route = component.route
    route.component = component
    routes.push route
  return { routes, root }
