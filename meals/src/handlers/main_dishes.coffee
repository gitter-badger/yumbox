Q = require 'q'
_ = require 'lodash'

module.exports = (server, options) ->
  MainDish = require('../models/main_dish') server, options

  privates =
    detail: (request, reply) ->
      key = request.params.key
      MainDish.get(key)
        .then (main_dish) ->
          return reply Boom.badImplementation "something's wrong" if main_dish instanceof Error
          reply.success main_dish.mask()

  return {
    app:
      detail: (request, reply) ->
        privates.detail(request, reply)

    dashboard:
      create: (request, reply) ->
        main_dish = new MainDish request.payload
        main_dish.create(true)
          .then (result) ->
            reply.success result
           
      toggle_availabilitty: (request, reply) ->
        key = request.params.key
        MainDish.get(key)
          .then (main_dish) ->
            main_dish.doc.is_available = not main_dish.doc.is_available
            main_dish.update()
          .then (result) ->
            return reply Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result

      detail: (request, reply) ->
        privates.detail(request, reply)

      list_all: (request, reply) ->
        MainDish.list_all()
          .then (results) ->
            return reply Boom.badImplementation "something's wrong" if results instanceof Error
            reply.nice results
      
      edit: (request, reply) ->
        payload = request.payload
        main_dish_key = request.params.key
        main_dish = new MainDish main_dish_key, payload
        main_dish.update(true)
          .then (result) ->
            return reply Boom.badImplementation "something's wrong" if result instanceof Error
            reply.success true, result
          .done()

      remove: (request, reply) ->
        main_dish_key = request.params.key
        MainDish.remove(main_dish_key)
          .then (result) ->
            return reply Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result

      add_photo: (request, reply) ->
        main_dish_key = request.params.key
        MainDish.get(main_dish_key)
          .then (main_dish) ->
            main_dish.photo = request.payload.photo
            main_dish.update true
          .then (result) ->
            return reply Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result
  }
