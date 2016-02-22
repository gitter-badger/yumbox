Boom = require 'boom'
Q = require 'q'
_ = require 'lodash'
moment = require 'moment'

module.exports = (server, options) ->
  SideDish = require('../models/side_dish') server, options

  return {
    dashboard:
      create: (request, reply) ->
        side_dish = new SideDish request.payload
        side_dish.create(true)
          .then (result) ->
            reply.success result

  }
###
      payload = request.payload
      console.log payload
      side_dish = new SideDish
        name: payload.name
        isAvailable: payload.isAvailable
        
     side_dish.create(true) ->
       .then(result) ->
         reply result
 ###
