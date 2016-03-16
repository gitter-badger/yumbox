JWT   = require('jsonwebtoken') #used to sign our content
aguid = require('aguid')

#dir   = __dirname.split('/')[__dirname.split('/').length-1]
#file  = dir + __filename.replace(__dirname, '') + " -> "

module.exports = (request, callback) ->
  # payload is the object that will be signed by JWT below
  payload = jti : aguid() # v4 random UUID used as Session ID below

  # no email is set (means an anonymous person)
  payload.person = "anonymous"
  payload.person = aguid request.payload.email if request.payload?.email? # see: http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html#issDef
   #this will need to be extended for other auth: http://git.io/pc1c

  token = JWT.sign payload, process.env.JWT_SECRET # http://git.io/xPBn
