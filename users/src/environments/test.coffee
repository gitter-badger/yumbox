module.exports = (server, options) ->
  Users     = require('../handlers/user') server, options
  server.route [
    {
      method: 'GET'
      path: '/v1/test/users/verification_code'
      config:
        handler: Users.test.get_verification_code
        auth: 'session'
        description: 'Get user verification code'
        tags: ['test', 'verification code']
     }
  ]
