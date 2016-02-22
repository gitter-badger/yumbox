module.exports = (server, options) ->

  Handler = require('../handler') server, options

  [
    {
      method: 'GET'
      path: '/app/join'
      config:
        handler: (request, reply) ->
          reply.view 'app/join'
        description: 'Form for user to join a hostel'
        tags: ['web', 'user']
    }
    {
      method: 'GET'
      path: '/app/verify'
      config:
        handler: Handler.users.verify
        description: 'Verify email address of app user'
        tags: ['web', 'user', 'email']
    }
    {
      method: 'GET'
      path: '/app/pin/{pin}'
      config:
        handler: Handler.users.pin
        description: 'Show PIN to user'
        tags: ['web', 'user', 'pin']
    }
    {
      method: 'GET'
      path: '/assets/app/js/{path*}'
      config: {
        handler: { directory: { path: __dirname + '/../app' } }
        description: 'Load app js files'
        tags: ['web', 'js']
      }
    }
  ]
