module.exports = (plugin, options, next) ->
  server = plugin.select 'api'

  server.route require('./routes/orders') server, options
  next()
