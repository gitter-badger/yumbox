module.exports = (server, options) ->
  
  Customers = require('./handlers/customers') server, options
  CustomerValidator = require './models/customerValidator'

  return [
    {
      method: 'POST'
      path: '/v1/app/customers/signup'
      config:
        handler: Customers.app.sign_up
        description:'customer sign up'
        tags: ['customer', 'signup']
    }
    {
      method: 'POST'
      path: '/v1/app/customers/signin_request'
      config:
        handler: Customers.app.request_verification_pin
        description:'customer sign in request'
        tags: ['customer', 'signin']
    }
    {
      method: 'POST'
      path: '/v1/app/customers/signin'
      config:
        validate: CustomerValidator::app.verify_pin
        handler: Customers.app.verify_pin
        description:'customer sign in'
        tags: ['customer', 'signin']
    }
  ]
