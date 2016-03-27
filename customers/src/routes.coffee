module.exports = (server, options) ->
  
  Customers = require('./handlers/customers') server, options
  CustomerValidator = require './models/customerValidator'

  return [
    {
      method: 'POST'
      path: '/v1/app/signup'
      config:
        handler: Customers.app.sign_up
        description:'customer sign up'
        tags: ['customer', 'signup']
    }
    {
      method: 'POST'
      path: '/v1/app/signin_request'
      config:
        handler: Customers.app.request_verification_pin
        description:'customer sign in request'
        tags: ['customer', 'signin']
    }
    {
      method: 'POST'
      path: '/v1/app/signin'
      config:
        validate: CustomerValidator::app.verify_pin
        handler: Customers.app.verify_pin
        description:'customer sign in'
        tags: ['customer', 'signin']
    }
    {
      method: 'GET'
      path: '/v1/app/orders'
      config:
        #validate: CustomerValidator::app.orders.history
        pre: [
          method: Customers.before_handler.me, assign: 'me'
        ]
        auth: 'jwt'
        handler: Customers.app.orders.history
        description:'customer history of orders'
        tags: ['customer', 'order', 'history']
    }
  ]
