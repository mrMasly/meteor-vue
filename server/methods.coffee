import { normalize } from 'path'

Module = module.parent

__modules = {}

Meteor._methods = Meteor.methods
Meteor.methods = (mod, methods) ->
  unless methods?
    Meteor._methods mod
  else
    # регистрируем модуль
    Meteor.registerModule mod
    for method, cb of methods
      do =>
        cb1 = cb
        if mod.id.indexOf('.vue')+1
          _name = mod.id
        else
          _name = mod.id
            .replace '/index.coffee.js', ''
            .replace '.js', ''
            .replace '.coffee', ''
        name = "#{_name}--method--#{method}"
        __modules[name] = mod
        newCb = ->
          if __modules[name].access @userId
            # возвращаем cb, с привязанным this
            return cb1.apply @, arguments
          else return null
        Meteor._methods
          "#{name}": newCb
