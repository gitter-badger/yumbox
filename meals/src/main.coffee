module.exports = (plugin, options, next) ->
  server = plugin.select 'api'
  server.route require('./routes') server, options
  require('./methods') server, options
  next()

