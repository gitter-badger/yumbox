module.exports = (server) ->

  settings = require "./config"

  config = settings.config
  defaults = settings.defaults

  db        = require('puffer').instances[config.databases.application.name]
  analytics = require('puffer').instances[config.databases.analytics.name]
 # redis     = require("redis").createClient config.cache.port, config.cache.host

  api = server.select 'api'
  web = server.select 'web'

 # redis.get "#{config.app}.cacheserver", (err, res) ->
 #   if err
 #     console.warn 'Cache server is not working ...'
 #   else
 #     console.info "Cache server is at #{config.cache.host}:#{config.cache.port}"

  server.register [
    { register: require('hapi-auth-cookie') }
    {
      register: require 'vision'
    }
    {
      register: require 'inert'
    }
    {
      register: require 'lout'
    }
    {
      register: require("good"),
      options: {
        reporters: [
          {
            reporter: require('good-console'),
            events: { log: '*', response: '*' }
          }
        ]
      }
    }
    ], (err) ->
        throw err if err
        server.auth.strategy 'session', 'cookie', {
          password: 'secret'
          isSecure: false
        }

  server.register [
    {
      register: require('hapi-io')
      options:
        auth:
          mode: 'try'
          strategy: 'session'
        connectionLabel: 'api'
    }
  ], (err) ->
       throw err if err

  server.select(['web', 'api']).register [
    {
      register: require('yumbox.meals')
      options:
        database: db
    }
    {
      register: require('yumbox.order')
      options:
        database: db
    }
    {
      register: require('yumbox.customer')
      options:
        database: db
    }
  ], (err) ->
        throw err if err
      server.start () ->
        console.info 'API server started at ' + server.select('api').info.uri
        console.info 'Web server started at ' + server.select('web').info.uri

