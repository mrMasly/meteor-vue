import Vue from 'vue'
import { resolve, dirname } from 'path'


Plugin = {}

Plugin.install = (vue, options) ->

  vue.mixin
    created: () ->
      if @$options.module
        Meteor.registerModule @$options.module
    methods:
      $call: (args...) ->
        if @$options.meteor.server?
          server = @$options.meteor.server
          module = @$options.module
          # console.log module
          if(typeof server is 'string')
            _name = resolve(dirname(module.id), server)
              .replace('.coffee', '')
              .replace('/index.js', '')
          else
            _name = module.id.split('.vue')[0] + '.vue'
          name = args.shift()
          name = "#{_name}--method--#{name}"
          args.unshift(name)
        Meteor.call args...

Vue.use Plugin
