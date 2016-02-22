UUID    = require 'node-uuid'
moment  = require 'moment'
Boom    = require 'boom'
Q       = require 'q'
_       = require 'lodash'

module.exports = (server, options) ->
  return class UserEmail extends server.methods.model.Base()
    
    PREFIX: 'e'
    
    props:
      user_key:     true
      verification: false
      auth:         false

    constructor: (key, doc, all) ->
      super @_key(key), doc, all
       
    @get_by_email: (email, raw=false)->
      @get @::_key(email), raw

    _isValid: ->
      UserEmail.get(@key).then (data) =>
        return true if data instanceof Error
        Boom.conflict 'Email is already taken'
    
    before_create: ->
      @doc.auth = UUID.v4() unless @doc.auth?
      @_set_verification()
      @_isValid()
    
    after_create: (data) ->
      server.methods.bookings.to_guests_by_email(@).then -> data
    
    verify: (code) ->
      if @doc.verification.code == code && moment().isBefore( @doc.verification.expires_at )
        if @doc.verification.verified_at == null
          @doc.verification.verified_at = moment().format()
          @update()
        else
          Q(new Error 'AlreadyVerifiedError')
      else
        Q(new Error 'CantVerify')
    
    #
    # Generate a token which will be deleted once it is used
    #
    generate_pin: ->
      @doc.recovery = { pin: _.random(1000, 9999), tries: 0 }
      @update()

    verify_pin: (pin)->
      return Q false unless @doc.recovery?
      @doc.recovery.tries += 1
      if pin == @doc.recovery.pin && @doc.recovery.tries < options.defaults.verification.try
        delete @doc.recovery
        @update('auth,user_key')
      else
        @update().then -> false
        

    @change: (user_key, old_address, new_address) ->
      @get_by_email(old_address, true)
        .then (old_email) =>
          old_doc = old_email.value
          return Boom.notFound "Can't find email for this user" unless old_doc.user_key is user_key
          new_email = new UserEmail new_address, old_doc
          new_email.doc.auth = old_doc.auth
          new_email.create().then (data) =>
            return data if data instanceof Error
            if old_doc.verification.verified_at is null
              UserEmail.remove @::_key old_address

    _set_verification: ->
      @doc.verification =
        code: UUID.v4()
        expires_at: moment().add(options.defaults.verification.expiry, 'day').format()
        verified_at: null

    _key: (email) -> ("#{UserEmail::PREFIX}:#{email}").toLowerCase()

    _key_to_email: -> (@key.split("#{UserEmail::PREFIX}:")[1]).toLowerCase()
