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
  }
