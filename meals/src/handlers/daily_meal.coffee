Q = require 'q'
_ = require 'lodash'
mask = require('json-mask')

module.exports = (server, options) ->
  DailyMeal = require('../models/daily_meal') server, options
  MainDish = require('../models/main_dish') server, options
  SideDish = require('../models/side_dish') server, options

  return {
    app:
      feed: (request, reply) ->
        feed = []
        promises = []

        DailyMeal.get_upcomings()
          .then (results) ->
            _.each results, (result) ->
              promises.push Q.fcall =>
                MainDish.find(result.main_dish_key)
                  .then (main_dish) ->
                    result.main_dish = main_dish
                  .then ->
                    SideDish.find(result.side_dish_keys, "name,doc_key")
                  .then (side_dishes) ->
                    result.side_dishes = side_dishes
                  .then ->
                    mask(result, "doc_key,total,main_dish,side_dishes,remained")
                
            Q.all(promises)
              .then (result) ->
                reply.nice result
            # find main dish detail
            # find each side dish detail
            # combine them together
            
            # return
        
    dashboard:
      create: (request, reply) ->
        daily_meal = new DailyMeal request.payload
        daily_meal.create(true)
          .then (result) ->
            reply.success result

      get_detail: (request, reply) ->
        key = request.params.key
        DailyMeal.get(key)
          .then (meal) ->
            main_dish_key = meal.doc.main_dish
            side_dishes_key = meal.doc.side_dishes
            SideDish.find(side_dishes_key)
              .then (sidedishes) ->
                MainDish.find(main_dish_key)
                 .then (maindish) ->
                   meal.doc.main_dish = maindish
                   meal.doc.side_dishes = sidedishes
                   reply meal.doc
                
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
