import _ from 'lodash'

allow = []
registered = []
_startup = no
# после загрузки всех файлов - находим и читаем права доступа
Meteor.startup ->
  _startup = yes
  for key, value of Meteor.allow
    if _.isString value
      value = groups: [value]
    else if _.isArray value
      value = groups: value
    value.users ?= []
    value.groups ?= []
    allow.push rule: key, access: value
    allow = _.sortBy allow, (a) -> - a.rule.length


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
          unless _.isEmpty a.access.users
            module.allow.users = _.union module.allow.users, a.access.users
          unless _.isEmpty a.access.groups
            module.allow.groups = _.union module.allow.groups, a.access.groups
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
        if _.isArray user.groups
          for group in user.groups
            if group in @allow.groups
              return yes
        return no
