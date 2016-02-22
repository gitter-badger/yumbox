module.exports = (server, options) ->

  Handler = require('../handler') server, options

  [
    {
      method: 'GET'
      path: '/plugins.js'
      config:
        handler: Handler.plugins.load
        description: 'Load hostel plugins'
        tags: ['plugin']
    }
    {
      method: 'GET'
      path: '/plugins/guests'
      config:
        handler: Handler.plugins.guests
        description: 'Load guest plugin'
        tags: ['plugin', 'guest']
    }
  ]
