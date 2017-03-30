
global.window = {}


Meteor.startup =>
  Module = module.parent
  for name, mod of Module.childrenById
    if name.indexOf('.vue')+1
      component = mod.exports.default
      if component?.meteor?.server?
        publishes = component.meteor.server.publish
        methods = component.meteor.server.methods
        if publishes?
          for name, func of publishes
            Meteor.publish mod, name, func
        if methods?
          Meteor.methods mod, methods
