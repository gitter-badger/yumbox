module.exports = (plugin, options, next) ->
  server = plugin.select 'api'

  server.route require('./routes/order') server, options
  next()
