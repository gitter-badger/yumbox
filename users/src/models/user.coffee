UUID    = require 'node-uuid'
Q = require 'q'
_ = require 'lodash'

module.exports = (server, options) ->
  UserEmail   = require('./user_email') server, options
  UserTimeline   = require('./user_timeline') server, options
  UserNotification   = require('./user_notification') server, options

  return class User extends server.methods.model.Base()
    
    UserProfile   = require('./user_profile') server, options, @
    PREFIX:       'u'
    PAGE_SIZE:    15
    AVATAR:
      SMALL:      "savatar"
      MEDIUM:     "mavatar"
    IMAGE_SIZE:
      SMALL:      [200, 200]
      MEDIUM:     [500, 500]

    props:
      name:           true
      gender:         true
      age:            false
      city:           true
      country:        true
      last_location:  true
      last_seen_at:   false
      avatar:         true
      email_address:  false # This is added to pass email address to Email class

    _mask: 'name,gender,city,country'

    constructor: (key, doc, all) ->
      super
      doc = key if not doc? and key instanceof Object
      @avatar = doc.avatar if doc.avatar?

    before_create: ->
      @email = new UserEmail @email_address, { user_key: @key }
      @email.create().then (data) =>
        return false if not data or data instanceof Error
        true

    before_save: ->
      if @doc.avatar?
        @avatar = @doc.avatar
        delete @doc.avatar
      true
    
    @find_by_email: (email_address, mask)->
      UserEmail.get_by_email( email_address )
        .then (email) ->
          return email if email instanceof Error
          User.find(email.doc.user_key, mask)

    @generate_pin_for_email: (email_address)->
      UserEmail.get_by_email( email_address )
        .then (email) ->
          return email if email instanceof Error
          Q.all([email.generate_pin(), User.find(email.doc.user_key, 'name,doc_key')])
            .then (results) ->
              user = results[1]
              PinMail = require('../mails/pin') server, options
              mail = new PinMail()
              mail.send email_address, { pin: email.doc.recovery.pin, email: email_address, name: user.name, user_key: user.doc_key }


    after_save: (data) ->
      return data if data instanceof Error
      @_saveAvatar()

    after_create: (data) ->
      return data if data instanceof Error
      timeline = new UserTimeline @key, {}
      notification = new UserNotification @key, {}

      profile = new UserProfile @key, (@profile||{})
      profile.doc.email = @email_address

      Q.all([
        profile.create()
        timeline.create()
        notification.create()
        @_send_verification()
      ]).spread (profile, timeline, notification) -> profile

    _send_verification: ->
      VerificationMail = require('../mails/verification') server, options
      mail = new VerificationMail()
      mail.send @email_address, { user_key: @doc.doc_key, name: @doc.name, code: @email.doc.verification.code, email: @email_address }

    _saveAvatar: ->
      return Q() unless @avatar?
      @save_image(@avatar, User::AVATAR.MEDIUM, User::IMAGE_SIZE.MEDIUM)
        .then (saved_file_path) =>
          @save_image saved_file_path, User::AVATAR.SMALL, User::IMAGE_SIZE.SMALL

    report: ->
      @doc.report = true
      @update()

    @list_all: (page=0, login_counts) ->
      query = if login_counts?
        range:
          login_counts:
            gte: login_counts
      else
        match_all: {}
      query =
        size: 100
        from: page * 100
        body:
          query: query
          sort:
            "doc.last_seen_at":
              order: "desc"

      @search('user', query)
        .then (results) ->
          users = []
          _.each results.hits.hits, (result)->
            users.push result._source.doc
          users


