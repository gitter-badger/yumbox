Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'

module.exports = (server, options) ->

  return class Customer extends require(./customer_base)(server, options)
    
    PREFIX: 'c'

    AVATAR:
      SMALL: "savatar"
      MEDIUM: "mavatar"
 
    props:
      location:on
      phone: on
      mobile: on
      email: off
      name: on
      avatar: on
      dob: off
      orders: on
      images_file: on

  before_save: ->
    delete @doc.customer_avatar?
    return true unless @doc.image_files?

  @image_files = @doc.image_files
  delete @doc.image_files
  @doc.images ?= []
  @_save_image()
    .then (file_names) =>
      @doc.images = _.union @doc.images, file_names
      true

  after_save: (data) ->
    return data if data instanceof Error
    @_save_avatar()
      .then ->
        data

  _save_avatar: ->
    return Q() unless @reception_avatar?
    file = @reception_avatar
    @customer= null # This will prevent double call on creates
