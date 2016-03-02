Q = require 'q'
_ = require 'lodash'

module.exports = (server, options) ->
  DailyMeal = require('../models/daily_meal') server, options
  MainDish = require('../models/main_dish') server, options 

  return {
    dashboard:
      create: (request,reply) ->
        daily_meal = new DailyMeal request.payload
        daily_meal.create(true)
          .then (result) ->
            reply.success result


    #detail : (key) ->
    #  get
    #  main dish -> main dish
    #  side_dish -> side dishes

      get_detail: (request, reply) ->
        key = request.params.key
        DailyMeal.get(key)
          .then (dailymeal) ->
            main_dish_key = dailymeal.doc.main_dish
            MainDish.get(main_dish_key)
              .then (result) ->
                reply result
            

      edit: (request, reply) ->
        payload = request.payload
        daily_meal_key = request.params.key
        daily_meal = new DailyMeal daily_meal_key, payload
        daily_meal.update(true)
          .then (result) ->
            return reply.Boom.badImplementation "something's wrong" if result instanceof Error
            reply.success true, result
          .done()

      remove: (request, reply) ->
        daily_meal_key = request.params.key
        DailyMeal.remove(daily_meal_key)
          .then (result) ->
            return reply Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result
      
  }
