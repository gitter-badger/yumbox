Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'

module.exports = (server, options) ->

  return class Customer extends server.methods.model.Base()
    
    PREFIX:       'c'

  props:
    location:on
    phone: on
    mobile: on
    email: off
    name: on
    customer_avatar: on
    dob: off
    orders: on

    AVATAR:
      SMALL:      "savatar"
      MEDIUM:     "mavatar"

    before_save: ->
      delete @doc.customer_avatar?
      return true unless @doc.customer_avatar? 

    after_save: (data) ->
      return data if data instanceof Error
      @_save_avatar()
        .then ->
          data

    _save_avatar: ->
      return Q() unless @reception_avatar?
      file = @reception_avatar
      @customer= null # This will prevent double call on creates
