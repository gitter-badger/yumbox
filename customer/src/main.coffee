module.exports = (plugin, options, next) ->
  server = plugin.select 'api'

  server.route require('./routes/customers') server, options
  next()
