Boom =    require 'boom'
Q =       require 'q'
_ =       require 'lodash'
moment =  require 'moment'
Joi =     require 'joi'

module.exports = (server, options) ->
  return class UserNotification extends server.methods.model.Base()
    PREFIX: false
    POSTFIX: ':notification'

    props:
      list:true

    constructor: (key, doc, all) ->
      key = @_key key
      super

    before_create: ->
      @doc.list = [] unless @doc.list?
      true

    @get_or_create: (doc_key) ->
      notification_key = @_key doc_key
      @get(notification_key)
        .then (notification) =>
          if notification instanceof Error
            notification = new UserNotification notification_key, {}
            notification.create()
              .then -> notification
          else
            notification

    validate_item: (notification_item) ->
      schema = Joi.object().keys
        data: Joi.object()
        doc: Joi.object().required().keys
          user_key:   Joi.string().required()
          data:       Joi.object().keys({type:Joi.string().required()}).unknown(yes).required()
          title:      Joi.string().required()
          message:    Joi.string().required()
      Q Joi.validate(notification_item, schema)

    add: (notification_item) ->
      @validate_item(notification_item)
        .then (is_valid) =>
          return is_valid unless is_valid.error is null
          notification_item.doc.data.created_at = moment().format()
          @doc.list.unshift notification_item.doc
          @doc.list = _.dropRight @doc.list, @doc.list.length - options.defaults.notification_size
          @update()
            .then =>
              _.extend notification_item.data, notification_item.doc.data
              @_send notification_item.doc.data.type, notification_item.doc.user_key, notification_item.data
    
    @seen: (user_key, index) ->
      key = @_key user_key
      UserNotification.get(key)
        .then (notification) =>
          return Boom.notFound "notifications are missed" if notification instanceof Error
          item = notification.doc.list[index]
          return Boom.notFound "notification doesn't exists" unless item?
          item.seen_at = moment().format()
          notification.doc.list.splice index, 1, item
          notification.update()

    _send: (type, user_key ,data) ->
      template = switch type
        when "new_activity"         then "activities.new"
        when "reject_claim"         then "guests.reject"
        when "close_to_check_in"    then "guests.close_to_check_in"
        when "close_to_check_out"   then "guests.close_to_check_out"
        when "hostels_joined"       then "guests.joined"
        when "leave_review"         then "guests.leave_review"
        when "upcoming_activity"    then "activities.upcomings"
        when "passport_approval"    then "users.passport_approval"
        when "passport_rejection"   then "users.passport_rejection"
        when "shoutout"             then "messages.shoutout"

      doc =
        user_keys: [user_key]
        template: template
        data: data
      server.methods.notification.post(doc)
        
    _key: (id) ->
      UserNotification._key id
    
    @_key: (id) ->
      if id.indexOf(UserNotification::POSTFIX) > -1
        id
      else
        "#{id}#{UserNotification::POSTFIX}"
