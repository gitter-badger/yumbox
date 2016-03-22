module.exports = (redis) ->
  (decoded, request, callback) ->
    redis.get decoded.jti, (err, reply) ->
      callback(null, reply?)
