jwt = require 'jsonwebtoken'
aguid = require 'aguid'
module.exports = (server, options) ->

  Customer = require('../models/customer') server, options
  sms      = require('sms-broker') options.sms

  privates =
    sign: (request, customer) ->
      payload =
        jti : aguid()
        customer: customer.doc
      server.plugins['hapi-redis'].client
        .set payload.jti, JSON.stringify payload
      jwt.sign payload, options.secure_key

  app:
    sign_up: (request, reply) ->
      customer = new Customer request.payload
      customer.create()
        .then (result) ->
          return reply Boom.badImplementation result if result instanceof Error
          reply(customer.mask())
            .header('Authorization', privates.sign(request, customer))

    request_verification_pin: (request, reply) ->
      mobile = request.payload.mobile
      Customer.generate_pin(mobile)
        .then (pin) ->
          return reply.not_found "Mobile number is not registered" if pin is no
          msg = "کد امنیتی یام باکس: #{pin}"
          sms.send(msg, mobile)
        .then (result) ->
          return reply Boom.badImplementation result if result instanceof Error
          reply.success result.success

    verify_pin: (request, reply) ->
      pin = request.payload.pin
      mobile = request.payload.mobile
      Customer.verify_pin(mobile, pin)
        .then (customer) ->
          return reply.unauthorized customer if customer instanceof Error
          return reply.bad_request "sign in request is not submited" if customer is no
          reply.success(true)
            .header('Authorization', privates.sign(request, customer))
