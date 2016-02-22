_ = require 'lodash'
Q = require 'q'

module.exports = (server, options) ->

  UserNotification   = require('./models/user_notification') server, options


