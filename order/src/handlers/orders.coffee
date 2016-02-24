Q = require 'q'
_ = require 'lodash'

module.exports = (server, options) ->
  Order = require('../models/order') server, options

  return {
    dashboard:
      create: (request, reply) ->
        order = new Order request.payload
        order.create(true)
          .then (result) ->
            reply.success result
           
      edit: (request, reply) ->
        payload = request.payload
        order_key = request.params.key
        order = new Order side_dish_key, payload
        order.update(true)
          .then (result) ->
            return reply.Boom.badImplementation "something's wrong" if result instanceof Error
            reply.success true, result
          .done()

      remove: (request, reply) ->
        order_key = request.params.key
        Order.remove(order_key)
          .then (result) ->
            return reply Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result

  }
