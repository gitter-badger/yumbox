Q = require 'q'
_ = require 'lodash'
Boom = require 'boom'
module.exports = (server, options) ->
  SideDish = require('../models/side_dish') server, options

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

    add_photo: (request, reply) ->
      side_dish_key = request.params.key
      SideDish.get(side_dish_key)
        .then (side_dish) ->
          side_dish.photo= request.payload.photo
          side_dish.update true
        .then (result) ->
          return reply Boom.badImplementation "something's wrong" if result instanceof Error
          reply.nice result
    toggle_availabilitty: (request, reply) ->
      key = request.params.key
      SideDish.get(key)
        .then (side_dish) ->
          side_dish.doc.is_available = not side_dish.doc.is_available
          side_dish.update()
        .then (result) ->
          return reply Boom.badImplementation "something's wrong" if result instanceof Error
          reply.nice result

    detail: (request, reply) ->
      key = request.params.key
      SideDish.get(key)
        .then (side_dish) ->
          return reply Boom.badImplementation "something's wrong" if side_dish instanceof Error
          reply.nice side_dish.mask()
    list_all: (request, reply) ->
      SideDish.list_all()
        .then (results) ->
          return reply Boom.badImplementation "something's wrong" if results instanceof Error
          reply.nice results
