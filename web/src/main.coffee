Path = require 'path'

exports.register = (plugin, options, next) ->
  server = plugin.select 'web'
  server.register [
    {
      register: require 'hapi-assets'
      options: require './assets'
    }
    {
      register: require 'h2o2'
    }
  ], (err) ->
    server.views {
      engines: {
        jade: require 'jade'
      },
      path: __dirname
    }
  server.route require('./routes/dashboard') server, options
  server.route require('./routes/main') server, options
  next()

exports.register.attributes = {
  pkg: require('../package.json')
}

