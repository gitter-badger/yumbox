module.exports = (server, options) ->
  env = process.env.NODE_ENV || 'development'
  try
    require("./#{env}") server, options
  catch err
    console.log "WARNING: #{__dirname}/#{env}.coffee doesn't exists."
