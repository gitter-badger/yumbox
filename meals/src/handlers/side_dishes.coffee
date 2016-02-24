Q = require 'q'
_ = require 'lodash'

module.exports = (server, options) ->
  SideDish = require('../models/side_dish') server, options

  return {
    dashboard:
      create: (request, reply) ->
        side_dish = new SideDish request.payload
        side_dish.create(true)
          .then (result) ->
            reply.success result
           
      edit: (request, reply) ->
        payload = request.payload
        side_dish_key = request.params.key
        side_dish = new SideDish side_dish_key, payload
        side_dish.update(true)
          .then (result) ->
            return reply.Boom.badImplementation "something's wrong" if result instanceof Error
            reply.success true, result
          .done()

      remove: (request, reply) ->
        side_dish_key = request.params.key
        SideDish.remove(side_dish_key)
          .then (result) ->
            return reply Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result

      add_images: (request, reply) ->
        side_dish_key = request.params.key
        SideDish.get(side_dish_key)
          .then (side_dish) ->
            side_dish.doc.image_files = request.payload.images
            side_dish.update true
          .then (result) ->
            return reply.Boom.badImplementation "something's wrong" if result instanceof Error
            reply.nice result
  }
