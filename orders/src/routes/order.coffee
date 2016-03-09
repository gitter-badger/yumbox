OrderValidator = require '../models/orderValidator'

module.exports = (server, options) ->

  Order = require('../handlers/orders') server, options
 
  return [
    {
      method: 'POST'
      path: '/v1/app/orders'
      config:
        handler: Order.app.create
        payload:
          output: 'stream'
        description: 'Create an order.'
        tags: ['meal','app','order', 'create']
    }
    {
      method: 'GET'
      path: '/v1/app/orders/{key}'
      config:
        handler: Order.app.get_detail
        description: 'get detail of daily meal'
        tags: ['meal','dashboard','order', 'get']
    }
    {
      method: 'PUT'
      path: '/v1/app/orders/{key}'
      config:
        handler: Order.app.edit
        validate: OrderValidator::edit
        description: 'Updates order'
        tags: ['order', 'update','edit']
    }
    {
      method: 'DELETE'
      path: '/v1/app/orders/{key}'
      config:
        handler: Order.app.remove
        description: 'remove an order'
        tags: ['meal','dashboard','order', 'delete']
    }
]
