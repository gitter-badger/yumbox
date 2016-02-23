module.exports = (plugin, options, next) ->
  server = plugin.select 'api'

  server.route require('./routes/main_dishes') server, options
  next()

