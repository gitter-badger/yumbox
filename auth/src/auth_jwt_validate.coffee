module.exports = (redis) ->
  (decoded, request, callback) ->
    redis.get decoded.jti, (err, reply) ->
      console.log err,11
      console.log reply, 22
      return callback(null, false) unless reply? #session expired
      callback(null, true) #session is valid
