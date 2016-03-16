module.exports = (server) ->

  settings = require "./config"

  config = settings.config
  defaults = settings.defaults

  db        = require('puffer').instances[config.databases.application.name]
  analytics = require('puffer').instances[config.databases.analytics.name]
  redis     = require('redis').createClient config.cache.port, config.cache.host
  auth      = require('../../../auth')

  api = server.select 'api'
  web = server.select 'web'

  console.log auth
  redis.get "#{config.app}.cacheserver", (err, res) ->
    if err
      console.warn 'Cache server is not working ...'
    else
      console.info "Cache server is at #{config.cache.host}:#{config.cache.port}"
   
  server.register [
    { register: require('hapi-auth-cookie') }
    { register: require('hapi-auth-jwt2') }
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
        server.auth.strategy('jwt', 'jwt',
            {
              key: '49668235E3E74EEEDA09369EECC7CC59258EFACF90595C2CE37A61A0080DE389'
              validateFunc: -> 
              verifyOptions: { algorithms: [ 'HS256' ] }   #pick a strong algorithm 
            })

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
      register: require('yumbox.customers')
      options:
        database: db
    }
  ], (err) ->
        throw err if err
      server.start () ->
        console.info 'API server started at ' + server.select('api').info.uri
        console.info 'Web server started at ' + server.select('web').info.uri

