module.exports = (server, options) ->
  
  Admins = require('./handlers/admins') server, options
  AdminValidator = require './models/adminValidator'

  return [
    {
      method: 'POST'
      path: '/v1/dashboard/signin'
      config:
        validate: AdminValidator::dashboard.signin
        handler: Admins.dashboard.signin
        description:'admin sign in'
        tags: ['admin', 'signin']
    }
    {
      method: 'GET'
      path: '/v1/dashboard/signout'
      config:
        handler: Admins.dashboard.signout
        description:'admin sign out'
        auth: 'jwt'
        tags: ['admin', 'signout']
    }
  ]
