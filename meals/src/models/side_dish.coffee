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

    props:
      name: on
      images:  on
      remained: off
      total: off
      price: off
      description: off
     

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
        savers.push @save_image file, ShortID.generate(), SideDish::IMAGE.SIZE.MEDIUM

      Q.allSettled(savers)
        .then (paths) ->
          names = _.map paths, (path) -> _.last path.value.split "/"
   
