Boom = require 'boom'
Q = require 'q'
_ = require 'lodash'
moment = require 'moment'
Joi = require 'joi'

module.exports = (server, options) ->
  DailyMeal = require('../models/daily_meal') server, options
  MainDish = require('../models/main_dish') server, options
  SideDish = require('../models/side_dish') server, options

  return{
    dashboard:
      pre:
        get_my_main_dish_key: (request,reply) ->
          main_dish_key = request.auth.credentials.main_dish_key
          return reply Boom.unauthorized "unauthorized access" unless main_dish_key?
          reply hostel_key

      session: (request, reply) ->
        return reply.success false unless request.auth.credentials? and request.auth.credentials.hostel_key?
        MainDish.find(request.auth.credentials.main_dish_key, MainDish::MASKS.DASHBOARD)
          .then (main_dish)->
            main_dish.role = 'main_dish'
            reply.success true, main_dish 


      main_dish:
        create:(request, reply) ->
          payload = request.payload
          mainDish = new MainDish payload
          mainDish.create()
            .then (saved) ->
              return reply.general_error if saved instanceof Error
              return reply.success true, mainDish.mask(MainDish::MASKS.DASHBOARD)
            .done()

      add_images: (request, reply) ->
        main_dish_key = request.pre.my_main_dish_key
        MainDish.get(main_dish_key)
          .then (main_dish) ->
            main_dish.doc.image_files = request.payload.images
            main_dish.update true
          .then (result) ->
            return reply.Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result.images

      remove_image: (request, reply) ->
        main_dish_key = request.pre.my_main_dish_key
        MainDish.get(main_dish_key)
          .then (main_dish)->
            main_dish.remove_image request.params.image_name
          .then (result) ->
            return reply Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result

      set_main_image: (request, reply) ->
        main_dish_key = request.pre.my_main_dish_key
        Hostel.get(main_dish_key)
          .then (main_dish) ->
            main_dish.set_main_image request.params.image_name
          .then (result) ->
            return reply result if result instanceof Error
            reply.nice result

  }
###
        edit: (request, reply) ->
        remove:
        detail:
        list:
        search:
      side_dish:
        create:
        update:
        remove:
        get:
        list:
        search:
    daily_meal:
        create: (request, reply) ->
        update:
        remove:
        get:
        list:
        search:
 
###
