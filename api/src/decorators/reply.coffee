Boom = require 'boom'

module.exports = (server) ->
  server.decorate 'reply', 'nice', (data) ->
    return this.response( { data: data , error: null } )

  server.decorate 'reply', 'success', (bool, data=null) ->
    return this.nice { success: bool } unless data?
    data.success = bool
    this.nice data

  server.decorate 'reply', 'conflict', (message) ->
    return this.response Boom.conflict message

  server.decorate 'reply', 'not_found', (message) ->
    return this.response Boom.notFound message

  server.decorate 'reply', 'mask', (data, mask) ->
    return this.nice server.methods.json.mask data, mask
