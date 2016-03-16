Path = require 'path'

module.exports = (server, config) ->

  health = require('./health') server, config

  return [
    {
      method: 'GET'
      path: '/health'
      config:
        handler: health
    }
    {
      method: 'GET'
      path: '/cdn/{klass}/{key}/{name*}'
      config:
        handler: (request, reply) ->
          reply.file Path.join(
            __dirname,
            '../../shared',
            request.params.klass,
            server.methods.file.safe_path(request.params.key),
            request.params.name
          )
        #cache:
        #  expiresIn: 24 * 60 * 60 * 1000
        description: 'Serve uploaded images'
        tags: ['photo','images']
    }
  ]


