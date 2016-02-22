Q = require 'q'
_ = require 'lodash'

module.exports = (server, options) ->
  Country = require('../models/country') server, options

  return {
    app:
      suggest_hometown: (request, reply) ->
        Country.suggest(request.query.q)
          .then (suggestions) ->
            reply.nice suggestions

    admin:
      create: (request, reply) ->
        country = new Country request.payload
        country.create()
          .then ->
            reply.success true
  }
