Q = require 'q'
_ = require 'lodash'
mask = require('json-mask')

module.exports = (server, options) ->
  DailyMeal = require('../models/daily_meal') server, options
  MainDish = require('../models/main_dish') server, options
  SideDish = require('../models/side_dish') server, options

  privates =
    detail: (request, reply) ->
      key = request.params.key
      DailyMeal.get(key)
        .then (meal) ->
          main_dish_key = meal.doc.main_dish
          side_dishes_key = meal.doc.side_dishes
          SideDish.find(side_dishes_key)
            .then (side_dishes) ->
              return reply Boom.badImplementation "something's wrong" if side_dishes instanceof Error
              MainDish.find(main_dish_key)
                .then (main_dish) ->
                   return reply Boom.badImplementation "something's wrong" if main_dish instanceof Error
                   meal.doc.main_dish = main_dish
                   meal.doc.side_dishes = side_dishes
                   reply.nice meal.mask()
  return {
    app:
      detail: (request, reply) ->
        privates.detail(request, reply)

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
            # what we done:
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

      detail: (request, reply) ->
        privates.detail(request, reply)

      list_all: (request, reply) ->
        DailyMeal.list_all()
          .then (results) ->
            return reply Boom.badImplementation "something's wrong" if results instanceof Error
            reply.nice results
 
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
