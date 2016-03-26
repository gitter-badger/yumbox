module.exports = (server, options) ->
  
  Orders = require('./handlers/orders') server, options

  return [
    {
      method: 'POST'
      path: '/v1/orders'
      config: {
        handler: Orders.app.create
        auth: 'jwt'
        description: 'submit a new order'
        tags: ['create', 'order']
      }
    }
  ]
