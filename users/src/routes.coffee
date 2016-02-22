UserValidator = require './models/userValidator'

module.exports = (server, options) ->
  Users     = require('./handlers/user') server, options

  return [
    {
      method: 'GET'
      path: '/v1/configs'
      config:
        handler: Users.app.configs
        description: 'Get mobile app configs'
        tags: ['configs']
    }
    {
      method: 'POST'
      path: '/v1/users/login'
      config:
        handler: Users.app.login
        validate: UserValidator::app.login
        auth:
          mode: 'try',
          strategy: 'session'
        description: 'Create a session for a successfully logged in user.'
        tags: ['user', 'session']
    }
    {
      method: 'POST'
      path: '/v1/users/logout'
      config:
        handler: Users.app.logout
        auth: 'session'
        description: 'Expire the session for a user.'
        tags: ['user', 'session']
    }
    {
      method: 'POST'
      path: '/v1/users/signup'
      config:
        handler: Users.app.create
        payload:
          output: 'stream'
        validate: UserValidator::app.create
        description: 'Create a user in the system.'
        tags: ['user']
    }
    {
      method: 'POST'
      path: '/v1/dashboard/users/signup'
      config:
        pre:[
          {
            method: Users.before_handler.dashboard.me
            assign: 'hostel_key'
          }
        ]
        handler: Users.dashboard.create
        payload:
          output: 'stream'
        validate: UserValidator::dashboard.create
        auth: 'session'
        description: 'Create a user in the system.'
        tags: ['user']
    }
    {
      method: 'POST'
      path: '/v1/users/pin/generate'
      config:
        handler: Users.app.generate_pin
        validate: UserValidator::app.generate_pin
        description: 'Generate a pin for registered emails.'
        tags: ['user', 'pin']
    }
    {
      method: 'POST'
      path: '/v1/users/pin/verify'
      config:
        handler: Users.app.verify_pin
        validate: UserValidator::app.verify_pin
        description: 'Verify a pin for registered emails.'
        tags: ['user', 'pin']
    }
    {
      method: 'POST'
      path: '/v1/me/edit'
      config:
        handler: Users.app.edit
        payload:
          output: 'stream'
        validate: UserValidator::app.edit
        auth: 'session'
        description: 'Edit a user in the system.'
        tags: ['user']
    }
    {
      method: 'GET'
      path: '/v1/me/profile'
      config:
        handler: Users.app.profile
        auth: 'session'
        description: 'Get user profile'
        tags: ['user']
    }
    {
      method: 'POST'
      path: '/v1/me/locate'
      config:
        handler: Users.app.locate
        auth: 'session'
        description: 'Store new location of user'
        tags: ['user', 'location']
    }
    {
      method: 'GET'
      path: '/v1/me'
      config:
        handler: Users.app.me
        auth: 'session'
        description: 'Show my profile'
        tags: ['user']
    }
    {
      method: 'GET'
      path: '/v1/users/{user_key}'
      config:
        handler: Users.app.show
        validate: UserValidator::app.show
        description: 'Show a user profile'
        tags: ['user']
    }
    {
      method: 'GET'
      path: '/v1/dashboard/session'
      config:
        handler: Users.dashboard.session
        auth:
          mode: 'try',
          strategy: 'session'
        description: "Return true for hostel with a session"
        tags: ['hostel', 'session']
    }    
  ]
