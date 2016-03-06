Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'

module.exports = (server, options) ->
  return class MainDish extends server.methods.model.Base()
    PREFIX: 'm'

    IMAGE:
      SIZE:
        SMALL: [250, 200]
        MEDIUM: [300, 300]
        LARGE: [500, 400]

    MAIN_IMAGE_NAME:      'maindish'
    MAIN_IMAGE_FILENAME:  'maindish.jpg'
    MAIN_IMAGE_EXT:       'jpg'
 
    props:
      name: on
      price: on
      contains: on
      description: on
      calories: on
      images: off
      image_files: on
      isAvailable: on

    _mask: 'doc_key,name,price,contains,description,calories,images,isAvailable'

    constructor: (key, doc, all) ->
      super
      doc = key if not doc? and key instanceof Object
      @image_files = doc.image_files if doc.image_files?

    before_save: ->
      delete @doc.images
      return true unless @doc.image_files?

      @image_files = @doc.image_files
      delete @doc.image_files
      @doc.images ?= []
      @_save_image()
        .then (file_names) =>
          @doc.images = _.union @doc.images, file_names
          true

    _save_image: ->
      @image_files  = [@image_files] unless _.isArray @image_files
    #  has_main = (_.find @doc.images, (img)-> img.split('.')[0] is MainDish::MAIN_IMAGE_NAME)?

      savers = []
      savers.push @save_image _.pullAt(@image_files, 0)[0], MainDish::MAIN_IMAGE_NAME, MainDish::IMAGE.SIZE.MEDIUM #unless has_main
      for file in @image_files
        savers.push @save_image file, ShortID.generate(), MainDish::IMAGE.SIZE.MEDIUM

      Q.allSettled(savers)
        .then (paths) ->
          names = _.map paths, (path) -> _.last path.value.split "/"
