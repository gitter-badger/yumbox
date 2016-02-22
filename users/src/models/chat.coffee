UUID    = require 'node-uuid'
Q = require 'q'
_ = require 'lodash'
moment = require 'moment'
Boom = require 'boom'

module.exports = (server, options) ->

  return class Chat extends server.methods.model.Base()
    
    PREFIX: 'chat'

    props:
      from:           true
      to:             true
      last_message:   true
      users:          false
      seen:           false

    _mask: 'users,seen'
    
    @create_or_update: (message) ->
      from = message.doc.from
      to = message.doc.to
      last_message = {
        doc_key: message.key
        user_key: message.doc.user_key
        body: _.truncate(message.doc.body, { length: options.messages.summary })
        created_at: message.doc.created_at
      }
      chat = new Chat( { from: from, to: to, last_message: last_message } )
      Chat.get(chat.key)
        .then (obj) ->
          if obj instanceof Error
            return chat.create()
              .then (data) ->
                return data if data instanceof Error
                chat
          obj.update_with(from, last_message)
            .then (data) ->
              return data if data instanceof Error
              obj

    before_save: ->
      @doc.updated_at = moment().format()
      true

    update_with: (from, last_message) ->
      @doc.last_message = last_message
      @doc.users.push from unless _.includes @doc.users, from
      @mark_seen from, last_message.doc_key
      @update()

    mark_seen: (user_key, pm_key) ->
      index = _.findIndex @doc.seen, (o) -> o.user_key == user_key
      item = { user_key: user_key, doc_key: pm_key }
      if index < 0
        @doc.seen.push item
      else
        @doc.seen[index] = item

    before_create: ->
      @doc.users = [ @doc.to, @doc.from ]
      @doc.seen = [ { user_key: @doc.from, doc_key: @doc.last_message.doc_key } ]
      delete @doc.to
      delete @doc.from

    _key: ->
      if @doc.to < @doc.from
        from = @doc.to
        to = @doc.from
      else
        from = @doc.from
        to = @doc.to
      "#{Chat::PREFIX}:#{from}:#{to}"

    @get_for: (doc_key, user_key) ->
      return Q Boom.notFound() if doc_key.indexOf(user_key) < 0
      Chat.find(doc_key, '*')

    @list_for: (user_key, page=0) ->
      query =
        size: options.messages.list_size
        from: (page-1) * options.messages.list_size
        body:
          query:
            bool:
              must:
                match:
                  'doc.users': user_key
          sort:
            "doc.updated_at":
              order: "desc"

      @search('chat', query)
        .then (results) ->
          ids = []
          _.each results.hits.hits, (result)->
            ids.push result._id
          Chat.find(ids, '*')
            .then (chats) ->
              { list: chats, total: results.hits.total }
