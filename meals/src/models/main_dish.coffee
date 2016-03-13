Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'

module.exports = (server, options) ->
  return class MainDish extends server.methods.model.Base()
    PREFIX: 'm'

    PHOTO:
      SMALL:      "small"
      MEDIUM:     "medium"

    PHOTO_SIZE:
      SMALL:      [100, 100]
      MEDIUM:     [500, 500]

    props:
      name: on
      photo: on
      price: on
      contains: on
      description: on
      calories: on
      is_available: off

    _mask: 'doc_key,name,price,contains,description,calories,is_available'

    constructor: (key, doc, all) ->
      super
      doc = key if not doc? and key instanceof Object
      @photo= doc.photo if doc.photo?
      @doc.is_available = no

    before_save: ->
      delete @doc.photo
      true

    after_save: (data) ->
      return data if data instanceof Error
      @_save_photo()
        .then ->
          data

    @list_all: ->
      query =
        body:
          size: 1000
          query:
            match:
              "doc.is_available": true

      @search('main_dish', query)
        .then (results) ->
           ids = []
           _.each results.hits.hits, (result) ->
             ids.push result._id
           MainDish.find ids, 'doc_key,name'

    _save_photo: ->
      return Q() unless @photo?
      @save_image(@photo, MainDish::PHOTO.SMALL, MainDish::PHOTO_SIZE.SMALL)
        .then (saved_file_path) =>
          @save_image saved_file_path, MainDish::PHOTO.MEDIUM, MainDish::PHOTO_SIZE.MEDIUM
