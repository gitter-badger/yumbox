OrderValidator = require '../models/orderValidator'

module.exports = (server, options) ->

  Order = require('../handlers/orders') server, options
 
  return [
    {
      method: 'POST'
      path: '/v1/dashboard/orders'
      config:
        handler: Order.dashboard.create
        payload:
          output: 'stream'
        description: 'Create an order.'
        tags: ['meal','dashboard','order', 'create']
    }
    {
      method: 'PUT'
      path: '/v1/dashboard/orders/{key}'
      config:
        handler: Order.dashboard.edit
        validate: OrderValidator::edit
        description: 'Updates order'
        tags: ['order', 'update','edit']
    }
    {
      method: 'DELETE'
      path: '/v1/dashboard/orders/{key}'
      config:
        handler: Order.dashboard.remove
        description: 'remove an order'
        tags: ['meal','dashboard','order', 'delete']
    }
]
