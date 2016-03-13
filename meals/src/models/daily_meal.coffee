Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'
moment =  require 'moment'

module.exports = (server, options) ->
  return class DailyMeal extends server.methods.model.Base()
    
    PREFIX: 'd'

    props:
      main_dish_key: on
      side_dish_keys: on
      at: on
      total: on
      remained: off

    _mask: 'main_dish,side_dishes,at,total,doc_key'
