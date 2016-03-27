Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
moment =  require 'moment'

module.exports = (server, options) ->
  return class Order extends server.methods.model.Base()
    
    PREFIX: 'o'

    props:
      customer_key: on
      daily_meal_key: on
      quantity: on
      at: off
      status: off
      price: off
    
    before_create: ->
      @doc.at = moment().format()
      @doc.status = "pending"
      true

    after_create: (data) ->
      server.methods.daily_meal.register_order(@doc)
        .then (result) =>
          return result if result instanceof Error
          server.methods.customer.add_order @doc
