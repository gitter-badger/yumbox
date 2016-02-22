Boom = require 'boom'
Q = require 'q'
_ = require 'lodash'
moment = require 'moment'

module.exports = (server, options) ->
  Message = require('../models/message') server, options
  Chat = require('../models/chat') server, options
  User = require('../models/user') server, options

  return {
    before_handler:
      app:
        me: (request, reply) ->
          key = request.auth.credentials.user_key
          return reply Boom.unauthorized "unauthorized access" unless key? && (!request.auth.credentials.device? || !request.auth.credentials.device)
          reply key

      dashboard:
        me: (request, reply) ->
          key = request.auth.credentials.hostel_key
          return reply Boom.unauthorized "unauthorized access" unless key?
          reply key

        find_me: (request, reply) ->
          key = request.auth.credentials.hostel_key
          return reply Boom.unauthorized "unauthorized access" unless key?
          server.methods.hostel.find(key)
            .then (hostel) ->
              return reply Boom.unauthorized "unauthorized access" if hostel instanceof Error
              reply hostel

    dashboard:
      shoutout: (request, reply) ->
        payload = request.payload
        server.methods.notification.emit('messages.shoutout', request.pre.hostel, payload.message)
        reply.success true

    app:
      create: (request, reply) ->
        me = request.pre.me
        Message.send( me, request.params.user_key, request.payload.body )
          .then (doc) ->
            return reply.conflict "Can't use user key" if doc instanceof Error
            reply.success true
          .done()

      chats: (request, reply) ->
        me = request.pre.me
        Chat.list_for(me, request.query.page)
          .then (chats) ->
            users = []
            _.each chats.list, (chat) ->
              _.each chat.users, (user) ->
                users.push user if _.indexOf(users, user) == -1
            User.find(users, 'name,doc_key', true)
              .then (users) ->
                chats.list = _.map chats.list, (chat) ->
                  chat.users = _.map chat.users, (user) -> users[user]
                  chat
                reply.nice chats

      chat: (request, reply) ->
        me = request.pre.me
        Chat.get_for(request.params.chat_key, me)
          .then (chat) ->
            return reply.not_found() if chat instanceof Error
            reply.nice chat

      messages: (request, reply) ->
        me = request.pre.me
        Message.list_for(request.params.chat_key, me, request.query.page)
          .then (chats) ->
            reply.nice chats

      seen: (request, reply) ->
        me = request.pre.me
        Message.mark_as_seen(request.params.pm_key, me)
          .then ->
            reply.success true
          .done()
  }
