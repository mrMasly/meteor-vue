# import _ from 'lodash'
import union from 'lodash.union'
import sortBy from 'lodash.sortby'

isArray = (array) -> Object.prototype.toString.call(array) is '[object Array]'
isString = (string) -> typeof string is 'string'

registered = []
_startup = no
# после загрузки всех файлов - находим и читаем права доступа
Meteor.startup ->
  allow = []
  _startup = yes
  for key, value of Meteor.allow
    if isString value
      value = groups: [value]
    else if isArray value
      value = groups: value
    value.users ?= []
    value.groups ?= []
    allow.push rule: key, access: value
  Meteor.allow = sortBy allow, (a) -> - a.rule.length
# запускает функцию после запуска метеора
run = (cb) ->
  if _startup then do cb
  else Meteor.startup => do cb


# зарегистрировать модуль
Meteor.registerModule = (module) ->

  if module.id in registered then return no
  else registered.push module.id

  if module.id.indexOf('/node_modules/meteor/') is 0
    module.name = module.id.split('/node_modules/meteor/')[1]
  else
    module.name = module.id.split('/')[1..].join('/')



  # при запуске метеора (ждем пока все файлы проекта закгрузятся)
  run =>

    module.allow ?= {}
    module.allow.users ?= []
    module.allow.groups ?= []

    if Meteor.allow.length is 0
      module.access = -> yes
    else
      # console.log Meteor.allow
      for a in Meteor.allow
        # console.log a.rule, module.name
        if module.name.indexOf(a.rule) is 0
          if a.access.users.length isnt 0
            module.allow.users = union module.allow.users, a.access.users
          if a.access.groups.length isnt 0
            module.allow.groups = union module.allow.groups, a.access.groups
          break

      # доступ к модулю
      module.access ?= (userId) ->
        userId ?= Meteor.userId()
        return no unless userId
        user = Meteor.users.findOne _id: userId,
          fields:
            username: 1
            groups: 1
        return no unless user?
        if 'all' in @allow.users
          return yes
        if user.username in @allow.users
          return yes
        if isArray user.groups
          for group in user.groups
            if group in @allow.groups
              return yes
        return no
