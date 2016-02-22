module.exports = (plugin, options, next) ->
  server = plugin.select 'api'

  server.route require('./routes/main_dish') server, options
  next()

