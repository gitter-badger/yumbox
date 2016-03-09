module.exports = (plugin, options, next) ->
  server = plugin.select 'api'

  server.route require('./routes/customer') server, options
  next()
