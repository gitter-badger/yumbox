Q = require 'q'
_ = require 'lodash'

module.exports = (server, options) ->
  MainDish = require('../models/main_dish') server, options

  return {
    dashboard:
      create: (request, reply) ->
        main_dish = new MainDish request.payload
        main_dish.create(true)
          .then (result) ->
            reply.success result

      add_images: (request, reply) ->
        main_dish_key = request.payload.doc_key
        MainDish.get(main_dish_key)
          .then (main_dish) ->
            main_dish.doc.image_files = request.payload.images
            main_dish.update true
          .then (result) ->
            return reply.Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result


  }
