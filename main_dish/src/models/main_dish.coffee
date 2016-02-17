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

    props:
      name: on
      total: off
      price: on
      remained: off
      contains: off
      description: off
      calories: off
      images: off
     

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
      for file in @image_files
        savers.push @save_image file, ShortID.generate(), MainDish::IMAGE.SIZE.MEDIUM

      Q.allSettled(savers)
        .then (paths) ->
          names = _.map paths, (path) -> _.last path.value.split "/"
   
   
