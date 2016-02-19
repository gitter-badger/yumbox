Hapi = require 'hapi'
Path = require 'path'
_    = require 'lodash'
Q    = require 'q'

config_path = "#{__dirname}/config"
#this is general config file in src/config

config = require("#{config_path}/config").config
#this is config.coffe inside src/config

server = new Hapi.Server

###{
    cache: {
      engine: require('catbox-redis')
      host:   config.cache.host
      port:   config.cache.port
    }
  }
###  
server.connection { port: Number(config.server.api.port), labels: 'api' }
server.connection { port: Number(config.server.web.port), labels: 'web' }
server.connection { port: Number(config.server.notification.port), labels: 'notification' }

load = ->
  require("#{__dirname}/methods/model")(server, config)
  require("#{__dirname}/methods/json")(server)
  require("#{__dirname}/methods/file")(server, config)
  require("#{__dirname}/decorators/reply")(server)

  server.select(['api', 'web']).route [
    {
      method: 'GET'
      path: '/cdn/{klass}/{key}/{name*}'
      config: {
        handler: (request, reply)->
          reply.file Path.join(__dirname, '../../shared', request.params.klass, server.methods.file.safe_path(request.params.key), request.params.name)
        cache: {
          expiresIn: 24*60*60*1000
        }
        description: 'Serve uploaded images'
        tags: ['images']
      }
    }
  ]
  require("#{config_path}/plugins")(server)


callback = (key) ->
  ->
    connected = config.databases[key].connected = config.databases[key].instance.bucket.connected
    name = config.databases[key].name
    if connected
      console.log "Connected to Couchbase Bucket #{name}!"
    else
      console.log "Error: Couchbase Bucket #{name} is shutdown. Byeee!"

    for k, v of config.databases
      return false unless v.connected?
      unless v.connected
        failed = true
        break

    return console.log "Server can't start. There was an issue with database." if failed?
    load()

for k, v of config.databases
  v.instance = null
  v.callback = callback k
  v.instance = new require('puffer') v
