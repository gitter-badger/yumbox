Q = require 'q'
_ = require 'lodash'
moment = require 'moment'


module.exports = (server, options) ->
  Order = require('../models/order') server, options
  {
    app:
      create: (request, reply) ->
        Q.ninvoke(server.plugins['hapi-redis'].client, "get", request.auth.credentials.jti)
          .then (reply) ->
            order = new Order _.extend request.payload,
              customer_key: JSON.parse(reply).customer.doc_key
            order.create(true)
          .then (result) ->
            return reply(result) if result instanceof Error
            reply(success: true).header('Authorization', request.headers.authorization)
          .done()
  }
