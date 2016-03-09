Q = require 'q'
_ = require 'lodash'

module.exports = (server, options) ->
  Order = require('../models/order') server, options
  DailyMeal = require('../../../meals/src/models/daily_meal') server, options
 # Customer = require('../../../customer/src/models/customer') server, options 

  return {
    app:
      create: (request, reply) ->
        order = new Order request.payload
        order.create(true)
          .then (result) ->
            reply.success result
           
      get_detail: (request, reply) ->
        order_key = request.params.key
        Order.get(order_key)
          .then (order) ->
           # customer_key = order.doc.customer_key
            daily_meal_key = order.doc.daily_meal_key
            DailyMeal.find(daily_meal_key)
              .then (dailymeal) ->
                #Customer.find(customer_key)
                # .then (customer) ->
                   order.doc.daily_meal_key = dailymeal
                  # order.doc.customer_key = customer
                   reply order.doc

       edit: (request, reply) ->
        payload = request.payload
        order_key = request.params.key
        order = new Order order_key, payload
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
