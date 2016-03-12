UUID    = require 'node-uuid'
_       = require 'lodash'
Device  = require './device'

module.exports = (server, options) ->

  return class CustomerBase extends server.methods.model.Base()

    before_create: ->
      @doc.bookmarks = [] unless @doc.bookmarks?
      @doc.history = [] unless @doc.history?
      @doc.auth = UUID.v4() unless @doc.auth?
      true

    history: (order_key) ->
      return if _.contains @doc.history, order_key
      @doc.history.unshift order_key
      @doc.history = _.take @doc.history, 10
