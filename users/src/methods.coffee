_ = require 'lodash'
module.exports = (server, options) ->

  User = require('./models/user') server, options
  UserProfile = require('./models/user_profile') server, options, User
  UserEmail = require('./models/user_email') server, options
  UserTimeline = require('./models/user_timeline') server, options
  UserNotification = require('./models/user_notification') server, options
  
  server.method 'users.find', (key, raw, as_object, with_profile = no, profile_mask) ->
    User.find(key, raw, as_object)
      .then (users) ->
        return users unless with_profile and as_object
        profile_keys = []
        _.map key, (k) -> profile_keys.push(k + UserProfile::POSTFIX)
        UserProfile.find(profile_keys, profile_mask, as_object)
          .then (profiles) ->
            _.each key, (k) ->
              users[k].profile = profiles[k + UserProfile::POSTFIX]
            return users
        
  server.method 'users.update_age', (user_key, age) ->
    user = new User user_key
    user.doc.age = age
    user.update true

  server.method 'users.get_profile', (user_key) ->
    UserProfile.get_by_user user_key
  
  server.method 'users.verify_email', (email_address, code)  ->
    UserProfile.verify_email email_address, code

  server.method 'users.has_minimum_verification_progress', (user_key) ->
    UserProfile.get_by_user(user_key)
      .then (profile) ->
        profile.doc.verification_progress >= options.defaults.minimum_verification_progress

  server.method 'users.get_extended', (user_key, profile_mask=["gender"], user_mask=["age"]) ->
    UserProfile.get_with_user user_key, profile_mask, user_mask

  server.method 'user_emails.get_by_email', (email) ->
    UserEmail.get_by_email email

  server.method 'users.timeline.add', (user_key, activity, type) ->
    UserTimeline.get_or_create(user_key)
      .then (timeline)->
        timeline.add activity, type

  server.method 'users.notify', (notification_item) ->
    UserNotification.get_or_create(notification_item.doc.user_key)
      .then (notification) ->
        notification.add notification_item
