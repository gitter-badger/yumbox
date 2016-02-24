_ = require 'lodash'

module.exports = (server, options) ->
  
  User = require('./customer') server, options
  return class Device extends require('./customer_base')(server, options)
    
    PREFIX:       'a'

    props:
      phone:         true
      auth:          false
      last_seen_at:  false
      last_location: false

    constructor: (key, doc, all) ->
      super @_key(key), doc, all

    @get_by_uuid: (uuid, raw=false)->
      @get @::_key(uuid), raw

    attach_phone: (phone) ->
      @doc.phone = phone
      @doc.verification = { pin: _.random(1000, 9999), tries: 0 }
      @_send_verification()
 
    verify_pin: (pin)->
      @doc.verification.tries += 1
      if pin == @doc.verification.pin && @doc.verification.tries < 5
        customer = new User
        customer.doc = _.merge customer.doc, @mask('phone,last_seen_at,last_location,bookmarks,history')
        customer.create('auth,doc_key')
          .then (customer_doc)=>
            Device.remove @key
            customer_doc
      else
        @update().then -> false
    
    _send_verification: ->
