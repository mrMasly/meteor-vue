# import _ from 'lodash'
import union from 'lodash.union'
import sortBy from 'lodash.sortby'

allow = []
registered = []
_startup = no
# после загрузки всех файлов - находим и читаем права доступа
Meteor.startup ->
  _startup = yes
  for key, value of Meteor.allow
    if typeof value is 'string'
      value = groups: [value]
    else if typeof value is 'array'
      value = groups: value
    value.users ?= []
    value.groups ?= []
    allow.push rule: key, access: value
    allow = sortBy allow, (a) -> - a.rule.length


# запускает функцию после запуска метеора
run = (cb) ->
  if _startup then do cb
  else Meteor.startup => do cb


# зарегистрировать модуль
Meteor.registerModule = (module) ->

  if module.id in registered then return no
  else registered.push module.id

  if module.id.indexOf('/node_modules/meteor/mrmasly:') is 0
    module.name = module.id.split('/node_modules/meteor/mrmasly:')[1]
  else
    module.name = module.id.split('/')[1..].join('/')

  # при запуске метеора (ждем пока все файлы проекта закгрузятся)
  run =>

    module.allow ?= {}
    module.allow.users ?= []
    module.allow.groups ?= []

    if allow.length is 0
      module.access = -> yes
    else

      for a in allow
        if module.name.indexOf(a.rule) is 0
          if a.access.users.length isnt 0
            module.allow.users = union module.allow.users, a.access.users
          if a.access.groups.length isnt 0
            module.allow.groups = union module.allow.groups, a.access.groups
          break

      # доступ к модулю
      module.access = (userId) ->
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
        if typeof user.groups is 'array'
          for group in user.groups
            if group in @allow.groups
              return yes
        return no
