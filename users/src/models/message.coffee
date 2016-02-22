UUID   = require 'node-uuid'
Q      = require 'q'
_      = require 'lodash'
moment = require 'moment'
Boom   = require 'boom'

module.exports = (server, options) ->
  User = require('./user') server, options
  Chat = require('./chat') server, options
  UserNotification   = require('./user_notification') server, options

  return class Message extends server.methods.model.Base()

    PREFIX: 'pm'

    props:
      name:           true
      from:           true
      to:             true
      body:           true
      created_at:     true

    @send: (from_id, to_id, body) ->
      User.get(from_id)
        .then (user) ->
          message = new Message { from: user.key, name: user.doc.name, to: to_id, body: body }
          message.create()

    before_create: ->
      return Boom.notFound "Can't find user"  if @doc.from == @doc.to
      @doc.user_key = @doc.from
      @to = @doc.to
      @from = @doc.from
      @name = @doc.name
      Chat.create_or_update( @ )
        .then (chat) =>
          return chat if chat instanceof Error
          @doc.chat_key = chat.key
          delete @doc.from
          delete @doc.to
          delete @doc.name
          true

    after_create: (data) ->
      server.methods.notification.emit 'messages.new', @
      data

    _key: ->
      now = moment()
      @doc.created_at = now.format()
      if @doc.to < @doc.from
        from = @doc.to
        to = @doc.from
      else
        from = @doc.from
        to = @doc.to
      "#{Message::PREFIX}:#{from}:#{to}:#{now}"

    @mark_as_seen: (pm_key, user_key) ->
      return Q false if pm_key.indexOf(user_key) < 0
      Message.find(pm_key, 'chat_key')
        .then (doc) ->
          Chat.get(doc.chat_key)
        .then (chat) ->
          chat.mark_seen user_key, pm_key
          chat.update()

    @list_for: (chat_key, user_key, page=0) ->
      return Q [] if chat_key.indexOf(user_key) < 0
      query =
        size: options.messages.list_size
        from: (page-1) * options.messages.list_size
        body:
          query:
            bool:
              must:
                match:
                  'doc.chat_key': chat_key
          sort:
            "doc.created_at":
              order: "desc"

      @search('pm', query)
        .then (results) ->
          ids = []
          _.each results.hits.hits, (result)->
            ids.push result._id
          Message.find(ids, '*')


