module.exports = (plugin, options, next) ->
  server = plugin.select 'api'
  server.route require('./routes/main_dishes') server, options
  server.route require('./routes/side_dishes') server, options
  server.route require('./routes/daily_meal') server, options
  require('./methods') server, options
  next()

