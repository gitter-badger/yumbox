Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'
moment =  require 'moment'

module.exports = (server, options) ->
  return class DailyMeal extends server.methods.model.Base()
    
    PREFIX: 'd'

    props:
      main_dish: on
      side_dishes: on
      at: on
      total: on
      remained: off
