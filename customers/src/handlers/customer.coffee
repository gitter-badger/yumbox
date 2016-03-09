Boom = require 'boom'
Q = require 'q'
_ = require 'lodash'
moment = require 'moment'

module.exports = (server, options) ->
  Customer = require('../models/customer') server, options
  Device = require('../models/device') server, options

  #CARDS =
   # SELL:   'sell'
    #SEARCH: 'search'

  privates =
    touch: (customer_or_device_key, request, is_device) ->
      key = customer_or_device_key
      request.auth.session.set { key: key, device: is_device } unless request.auth.isAuthenticated
      klass = if is_device then Device else Customer
      klass.get(key).then (obj) ->
        obj.doc.last_seen_at = moment().format()
        obj.doc.location = request.payload.location if request.payload.location?
        obj.update().then ->
          obj.mask('auth,doc_key')

  return {
    before_handler:
      me: (request, reply) ->
        key = request.auth.credentials.key
        return reply Boom.unauthorized "unauthorized access" unless key?
        reply key

      get_me: (request, reply) ->
        key = request.auth.credentials.key
        return reply Boom.unauthorized "unauthorized access" unless key?
        klass = if request.auth.credentials.device then Device else Customer
        klass.get(key)
          .then (me)->
            reply me
      
    app:
      me: (request, reply) ->
        reply.nice request.pre.me.mask('phone,doc_key,doc_type,bookmarks,history')

      create: (request, reply) ->
        device = new Device request.payload.device_id, request.payload
        device.create()
          .then (doc) ->
            return reply.conflict "Already taken" if doc instanceof Error
            request.auth.session.set { key: device.key, device: true }
            privates.touch( device.key, request, true )
              .then (doc)-> reply.success (doc)

      phone: (request, reply) ->
        Device.get(request.pre.me)
          .then (device) ->
            device.attach_phone request.payload.phone
            device.update()
          .then -> reply.success true

      verify: (request, reply) ->
        Device.get(request.pre.me)
          .then (device) ->
            return reply.not_found "Account does not exist" if device instanceof Error
            device.verify_pin( request.payload.pin )
              .then (doc) -> 
                request.auth.session.set { key: doc.doc_key } if doc.doc_key?
                reply.nice doc

      login: (request, reply) ->
        if request.auth.isAuthenticated
          key = request.auth.credentials.key
          privates.touch(key ,request, request.auth.credentials.device)
            .then (data) -> return reply.success true
        else
          instance = Customer.get request.payload.phone if request.payload.phone?
          instance = Device.get request.payload.device_id if request.payload.device_id?
          instance
            .then (obj) ->
              if obj instanceof Error or obj.doc.auth isnt request.payload.auth
                return reply Boom.unauthorized "Authentication failed. Check your credentials"
              key = obj.doc.doc_key
              privates.touch(key, request, request.payload.device_id?)
                .then (data)-> return reply.success true
            .done()
      
      configs: (request, reply) ->
        reply.nice options.mobile
      
      logout: (request, reply) ->
        request.auth.session.clear()
        reply.success true

      locate: (request, reply) ->
        privates.touch(request.pre.me, request, request.auth.credentials.device).then -> reply.success true

      feed: (request, reply) ->
        cards = []
        cards.push { type: CARDS.SELL }
        cards.push { type: CARDS.SEARCH }
        reply.nice cards
  }
