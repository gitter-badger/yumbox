UUID    = require 'node-uuid'
Q       = require 'q'
moment  = require 'moment'
Boom    = require 'boom'
bcrypt  = require 'bcrypt'

module.exports = (server, options) ->
  return class HostelEmail extends server.methods.model.Base()

    PREFIX: 'he'
    
    props:
      hostel_key:       true
      verification:     false
      password:         false
      address:          true

    constructor: (key, doc, all) ->
      super @_key(key), doc, all

    before_create: ->
      @_set_password().then =>
        @_set_verification()
        @_isValid()
    
    check_password: (password) ->
      Q.nfcall(bcrypt.compare, password, @doc.password)
        .then (result) ->
          result
    change_password: (current_password, new_password) ->
      @check_password(current_password)
        .then (is_pass_valid) =>
          return new Error "Old password doesn't match" unless is_pass_valid
          @password = new_password
          @_set_password().then =>
            @update()

    @get_by_email: (email, raw=false)->
      @get @::_key(email), raw

    _key: (email) -> ("#{HostelEmail::PREFIX}:#{email}").toLowerCase()

    _set_password: ->
      Q.nfcall(bcrypt.genSalt, 10)
        .then (salt) =>
          Q.nfcall(bcrypt.hash, @password, salt)
        .then (result) =>
          @doc.password = result
          delete @password

    _set_verification: ->
      @doc.verification =
        code: UUID.v4()
        expires_at: moment().add(options.defaults.email_verification_expiry_due, 'day').format()
        verified_at: null

    _isValid: ->
      HostelEmail.get(@key).then (data) =>
        return true if data instanceof Error
        Boom.conflict 'Email is already taken'
