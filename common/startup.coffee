import Vue from 'vue'
import VueRouter from 'vue-router'
import VueMeta from './vue-meta.js'
Vue.use VueRouter

if Meteor.isClient
  __meteor_runtime_config__.VUE_DEV_SERVER_URL = location.hostname+':'+(Number(location.port)+3)

Vue.use VueMeta,
  keyName: 'head'

createApp = ->

  { routes, root } = mapModules()

  defaultRoute = null
  for route in routes
    if route.default
      defaultRoute =
        path: '/'
        redirect: name: route.name

  routes.push defaultRoute if defaultRoute?

  router = new VueRouter
    routes: routes
    mode: 'history'

  options =
    el: '#app'
    router: router
    render: (h) -> h root

  options.head =
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' }
      { name: 'apple-mobile-web-app-capable', content: 'yes' }
    ]

  if Meteor.isClient and Meteor.ssr is no
    options.mounted = -> setTimeout =>
      el = document.getElementById 'mrmasly-vue-loading'
      document.body.removeChild el
    , 500
    options.head =
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' }
        { name: 'apple-mobile-web-app-capable', content: 'yes' }
      ]
  if Meteor.Store
    options.store = Meteor.Store

  Meteor.Vue = new Vue options

  app: Meteor.Vue
  router: router


Meteor.startup ->
  if Meteor.isServer
    # если ssr отключен
    if Meteor.ssr is no
      VueSSR.template = '''
        <div id="app"></div>
        <div id="mrmasly-vue-loading" style="position:absolute;top:0;left:0;width:100%;height:100%;display:flex;justify-content:center;align-items:center;z-index:9999999999;background-color:#fff">
          <img style="flex:1;width:120px;height:120px" src="/packages/mrmasly_vue/public/gears.svg" />
        </div>
      '''
    # если ssr включен
    else
      VueSSR.template = '<div id="app"><!--vue-ssr-outlet--></div>'
      VueSSR.createApp = (url) ->
        { app, router } = createApp()
        router.push path: url.url
        return app

  else
    createApp()

Meteor.Components = []
getComponents = ->
  return if Meteor.Components.length
  Module = module.parent
  for id, mod of Module.childrenById
    Meteor.registerModule mod
    continue if id.indexOf('.vue') is -1
    component = mod.exports.default
    Meteor.Components.push component

Meteor.Components = []
mapModules = ->
  do getComponents
  routes = []
  root
  Module = module.parent
  for component in Meteor.Components
    root = component if component.root?
    continue unless component.route?
    route = component.route
    route.component = component
    route.module = component.module
    routes.push route

  return { routes, root }
