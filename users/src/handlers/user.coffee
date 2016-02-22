Boom = require 'boom'
Q = require 'q'
_ = require 'lodash'
moment = require 'moment'

module.exports = (server, options) ->
  User = require('../models/user') server, options
  UserEmail = require('../models/user_email') server, options
  UserProfile = require('../models/user_profile') server, options, User
  UserTimeline = require('../models/user_timeline') server, options
  UserNotification= require('../models/user_notification') server, options
  Country = require('../models/country') server, options

  privates =
    touch: (user_key, request, is_login=false) ->
      request.auth.session.set { user_key: user_key } unless request.auth.isAuthenticated
      User.get(user_key).then (user) ->
        user.doc.last_seen_at = moment().format()
        user.doc.last_location = request.payload.last_location if request.payload.last_location?
        if is_login
          user.doc.login_counts = (user.doc.login_counts || 0)+1
        user.update().then ->
          if is_login
            privates.user_with_verification user
          else
            user.mask()

    user_with_verification: (user) ->
      UserProfile.get_with_user(user.doc.doc_key)
        .then (profile)->
          doc = user.mask('name,country,city')
          doc.verification_progress = profile.verification_progress
          doc.interests = profile.interests
          doc

    show: (user_key, is_mine) ->
      user = {}
      UserTimeline.get_or_create(user_key)
        .then (timeline) ->
          user.timeline = _.takeRight(timeline.doc.list, 100)
        .then ->
          UserProfile.get_with_user(user_key)
        .then (profile)->
          return unless profile?
          user.verification_progress = profile.verification_progress if is_mine
          user.interests = profile.interests if profile.interests?
          user.country = profile.country if profile.country?
          user.city = profile.city if profile.city?
          user.name = profile.name if profile.name?
          user.gender = profile.gender if profile.gender?
          user.doc_key = profile.doc_key
        .then ->
          user

  return {
    before_handler:
      admin:
        is_logged_in: (request, reply) ->
          is_admin = request.auth.credentials.is_admin
          return reply Boom.unauthorized "unauthorized access" unless is_admin? && is_admin
          reply true

      dashboard:
        me: (request, reply) ->
          key = request.auth.credentials.hostel_key
          return reply Boom.unauthorized "unauthorized access" unless key?
          reply key

    app:
      report: (request, reply) ->
        User.get(request.params.user_key)
          .then (user) ->
            user.report()
          .then ->
            reply.success true

      generate_pin: (request, reply) ->
        User.generate_pin_for_email( request.payload.email )
          .then (doc) ->
            return reply.not_found "Email does not exist" if doc instanceof Error
            reply.success true
          .done()

      verify_pin: (request, reply) ->
        UserEmail.get_by_email( request.payload.email )
          .then (email) ->
            return reply.not_found "Email does not exist" if email instanceof Error
            email.verify_pin( request.payload.pin )
              .then (doc) ->
                return reply.success false unless doc
                privates.touch(doc.user_key, request, true)
                  .then (data)->
                    data.doc_key = doc.user_key
                    data.auth = doc.auth
                    reply.nice data
          .done()

      login: (request, reply) ->
        if request.auth.isAuthenticated
          user_key = request.auth.credentials.user_key
          privates.touch(user_key ,request, true)
            .then (data) ->
              return reply.success true, data
            .done()
        else
          UserEmail.get_by_email(request.payload.email)
            .then (user_email) ->
              if user_email instanceof Error or user_email.doc.auth isnt request.payload.auth
                return reply Boom.unauthorized "email/auth didn't match"
              user_key = user_email.doc.user_key
              privates.touch(user_key,request, true)
                .then (data)->
                  return reply.success true, data
            .done()

      logout: (request, reply) ->
        request.auth.session.clear()
        reply.success true
      
      configs: (request, reply) ->
        reply.nice options.mobile

      create: (request, reply) ->
        payload = request.payload

        user = new User payload
        user.email_address = payload.email
        user.profile = server.methods.json.mask payload, 'dob,passport,gender,interests'

        user.create()
          .then( (saved)->
            if saved instanceof Error
              reply.conflict "User #{user.email_address} already exists"
            else
              privates.touch(user.key, request, true)
                .then (data)->
                  data.doc_key = user.key
                  data.auth = user.email.doc.auth
                  reply.nice data
          ).done()

      edit: (request, reply) ->
        payload = request.payload
        user_key = request.auth.credentials.user_key
        user = new User user_key, payload
        
        profile_updater = ->
          UserProfile.get_by_user(user_key)
            .then (profile) ->
              profile.check_and_update payload

        user.update()
          .then ->
            profile_updater()
          .then ->
            privates.touch(user_key, request)
          .then ->
            UserProfile.get_with_user(user_key)
          .then (data)->
            return reply.success true, data
          .done()

      dismiss_insurances: (request, reply) ->
        user_key = request.auth.credentials.user_key
        UserProfile.get_by_user(user_key)
          .then (profile) ->
            profile.doc.insurance_dismissed_at = moment().format()
            profile.update()
          .then (result) ->
            return reply.Boom.badImplementation "something's wrong" if result instanceof Error
            reply.success true

      update_interests: (request, reply) ->
        user_key = request.auth.credentials.user_key
        interests = request.payload.interests
        return reply.success false, "there's nothing to update!" unless interests? or _.isEmpty interests
        UserProfile.get_by_user(user_key)
          .then (profile) ->
            profile.doc.interests = interests
            profile.update()
          .then (result) ->
            return reply.Boom.badImplementation "somethings's wrong" if result instanceof Error
            reply.success true

      profile: (request, reply) ->
        user_key = request.auth.credentials.user_key
        UserProfile.get_for_edit(user_key)
          .then (profile) -> reply.nice profile

      me: (request, reply) ->
        my_key = request.auth.credentials.user_key
        privates.show(my_key, yes)
          .then (profile) -> reply.nice(profile)
          .done()

      show: (request, reply) ->
        user_key = request.params.user_key
        privates.show(user_key, no)
          .then (profile) -> reply.nice(profile)
          .done()

      locate: (request, reply) ->
        privates.touch(request.auth.credentials.user_key, request)
          .then ->
            reply.success true

      get_notification_list: (request, reply) ->
        user_key = request.auth.credentials.user_key
        UserNotification.get_or_create(user_key)
          .then (res) ->
            reply.nice res.doc.list

      notification_seen: (request, reply) ->
        user_key = request.auth.credentials.user_key
        notification_index = request.params.index
        UserNotification.seen(user_key, notification_index)
          .then (res) ->
            return reply.badImplementation res if res instanceof Error
            reply.success true
          .done()

    admin:
      list: (request, reply) ->
        User.list_all(request.query.from, request.query.login_counts)
          .then (users) ->
            reply.nice users

    dashboard:
      session: (request, reply) -> reply.success yes, null
      claim: (request, reply) ->
        payload = request.payload
        booking = payload.booking

        User.get( request.params.user_key )
          .then( (user) ->
            return user if user instanceof Error
            guest = if booking?.reference_number?
              server.methods.bookings.claim_or_create(request.pre.hostel_key, user.key, payload.email, booking.reference_number, booking.from, booking.to)
            else
              server.methods.guests.create(request.pre.hostel_key, user.key, booking.from, booking.to)
            guest.then (guest) ->
                guest = guest.mask()
                guest.user = user.mask()
                server.plugins['hapi-io'].io.to("hostel_#{request.pre.hostel_key}").emit('new_checkin', guest)
                reply.nice user.mask()
          ).done()

      confirm_passport: (request, reply) ->
        hostel_key = request.auth.credentials.hostel_key
        unless hostel_key?
          return reply Boom.unauthorized "unauthorized access"

        user_key = request.params.user_key
        confirmation_status = request.payload.confirmed
        UserProfile.get_by_user(user_key)
          .then (user_profile) ->
            user_profile.confirm_passport(hostel_key, confirmation_status)
          .then (result) ->
            if result instanceof Error
              return reply result
            else
              return reply.success true
        .done()

      create: (request, reply) ->
        payload = request.payload
        booking = payload.booking

        user = new User payload
        user.email_address = payload.email
        user.profile = server.methods.json.mask payload, 'dob,passport,gender,interests'

        user.create()
          .then( (saved) ->
            return reply.conflict "User #{user.email_address} already exists" if saved instanceof Error
            guest = if booking?.reference_number?
              server.methods.bookings.claim_or_create(request.pre.hostel_key, user.key, user.email_address, booking.reference_number, booking.from, booking.to)
            else
              server.methods.guests.create(request.pre.hostel_key, user.key, booking.from, booking.to)
            guest.then (guest) ->
                guest = guest.mask()
                guest.user = user.mask()
                server.plugins['hapi-io'].io.to("hostel_#{request.pre.hostel_key}").emit('new_checkin', guest)
                reply.nice user.mask()
          ).done()

      find: (request, reply) ->
        User.find_by_email(request.query.email, 'name,doc_key,city,country')
          .then (user) ->
            return reply.not_found "Email does not exist" if user instanceof Error
            reply.nice user


    test:
      get_verification_code: (request, reply) ->
        my_key = request.auth.credentials.user_key
        UserProfile.get_by_user(my_key)
          .then (profile) ->
            UserEmail.get_by_email(profile.doc.email)
          .then (result) ->
            reply.nice result.doc.verification.code
  }
