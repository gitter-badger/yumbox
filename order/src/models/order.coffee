Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'

module.exports = (server, options) ->
  return class Order extends server.methods.model.Base()
    
    PREFIX: 'o'

    props:
     customer_key: on
     daily_meal_key: on
     quantity: on
     at: on
     status: on
     price: on
     isCanceled: on

