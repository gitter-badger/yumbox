CustomerValidator = require '../models/customerValidator'

module.exports = (server, options) ->
  
  Customers = require('../handlers/customer') server, options

  me_before_handler = [
    {
      method: Customers.before_handler.me
      assign: 'me'
    }
  ]

  return [
    {
      method: 'GET'
      path: '/v1/configs'
      config:
        handler: Customers.app.configs
        description: 'Get apps configs'
        tags: ['app']
    }
    {
      method: 'GET'
      path: '/v1/me'
      config:
        pre:[
          {
            method: Customers.before_handler.get_me
            assign: 'me'
          }
        ]
        handler: Customers.app.me
        auth: 'session'
        description: 'Get me'
        tags: ['app']
    }
    {
      method: 'POST'
      path: '/v1/customers'
      config:
        handler: Customers.app.create
        validate: CustomerValidator::create
        auth:
          mode: 'try',
          strategy: 'session'
        description: 'Register a user with device UUID'
        tags: ['user', 'device']
    }
    {
      method: 'POST'
      path: '/v1/customers/login'
      config:
        handler: Customers.app.login
        validate: CustomerValidator::login
        auth:
          mode: 'try',
          strategy: 'session'
        description: 'Login a user with device UUID or phone'
        tags: ['user', 'device']
    }
    {
      method: 'POST'
      path: '/v1/customers/logout'
      config:
        handler: Customers.app.logout
        auth:
          mode: 'try',
          strategy: 'session'
        description: 'Logout a user'
        tags: ['user', 'device']
    }
    {
      method: 'POST'
      path: '/v1/me/locate'
      config:
        pre: me_before_handler
        handler: Customers.app.locate
        auth: 'session'
        description: "Update user's last location"
        tags: ['location']
    }
    {
      method: 'POST'
      path: '/v1/me/phone'
      config:
        pre: me_before_handler
        handler: Customers.app.phone
        validate: CustomerValidator::phone
        auth:
          strategy: 'session'
        description: "Attach a phone to user"
        tags: ['user', 'device']
    }
    {
      method: 'POST'
      path: '/v1/me/verify'
      config:
        pre: me_before_handler
        handler: Customers.app.verify
        validate: CustomerValidator::verify
        auth:
          strategy: 'session'
        description: "Verify customer's phone"
        tags: ['user', 'device']
    }
    {
      method: 'GET'
      path: '/v1/me/feed'
      config:
        pre: me_before_handler
        handler: Customers.app.feed
        auth:
          strategy: 'session'
        description: "Get customer's feed"
        tags: ['feed']
    }
  ]
