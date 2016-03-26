jwt = require 'jsonwebtoken'
_ = require 'lodash'
aguid = require 'aguid'
module.exports = (server, options) ->

  privates =
    sign: (request) ->
      server.plugins['hapi-redis'].client
        .set options.admin.jti, aguid()
      jwt.sign jti:options.admin.jti, options.secure_key

    verify_user_pass: (credentials) ->
      _.isEqual credentials, options.admin.credentials

  dashboard:
    signin: (request, reply) ->
      unless privates.verify_user_pass request.payload
        return reply.unauthorized("wrong username or password")
      reply(success: true).header 'Authorization', privates.sign request

    signout: (request, reply) ->
      server.plugins['hapi-redis'].client
        .del options.admin.jti, (err, result) ->
          reply.success result is 1


