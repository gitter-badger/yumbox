module.exports = (plugin, options, next) ->
  server = plugin.select 'api'
  server.route require('./routes/side_dishes') server, options
  server.route require('./routes/main_dish') server, options
  next()

