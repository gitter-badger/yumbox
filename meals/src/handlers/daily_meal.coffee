Boom = require 'boom'
Q = require 'q'
_ = require 'lodash'
moment = require 'moment'

module.exports = (server, options) ->
  DailyMeal = require('../models/daily_meal') server, options

  return
    create: (request, reply) ->
      payload = request.payload
      total = null
      daily_meal = new DailyMeal
        main_dish: [name: {payload.main_dish}]
        side_dishes: [name: {payload.side_dish}
        at: payload.at
        total: payload.total
        remained: {order} 
        
     daily_meal.create(true) ->
       .then(result) ->
         reply result
         
