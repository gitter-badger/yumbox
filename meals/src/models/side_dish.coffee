Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'

module.exports = (server, options) ->
  return class SideDish extends server.methods.model.Base()
    
    PREFIX: 's'

    IMAGE:
      SIZE:
        SMALL: [250, 200]
        MEDIUM: [300, 300]
        LARGE: [500, 400]

    MAIN_IMAGE_NAME:      'sidedish'
    MAIN_IMAGE_FILENAME:  'sidedish.jpg'
    MAIN_IMAGE_EXT:       'jpg'

    props:
      name: on
      images:  off
      image_files:on
      isAvailable: on

    constructor: (key, doc, all) ->
      super
      doc = key if not doc? and key instanceof Object
      @image_files = doc.image_files if doc.image_files?

    before_save: ->
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
      savers = []
      savers.push @save_image _.pullAt(@image_files, 0)[0], SideDish::MAIN_IMAGE_NAME, SideDish::IMAGE.SIZE.MEDIUM
 
      for file in @image_files
        savers.push @save_image file, ShortID.generate(), SideDish::IMAGE.SIZE.MEDIUM

      Q.allSettled(savers)
        .then (paths) ->
          names = _.map paths, (path) -> _.last path.value.split "/"
