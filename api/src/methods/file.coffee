Q = require 'q'
fs = require 'fs-extra'
gm = require 'gm'

Path = require 'path'

module.exports = (server, config) ->
  
  server.method 'file.root', () ->
    return config.file.path
  
  server.method 'file.safe_path', (path, size=2) ->
    size = new RegExp ".{1,#{size}}", 'g'
    path  = path.split ':'
    path[0] = path[0].match(size).join('/')
    return path.join('/')
  
  get_ext = (file) ->
    ext = Path.extname if typeof file is 'string'
      file
    else
      file.hapi.filename

  # ## server.methods.image.save
  #
  # Resize, crop and save images at any path. If the path doesn't exist, it will create it. It will return a deferred object using Q.
  #
  # @method
  # @private
  #
  # @param {Stream}        file   File which should be modified and saved
  # @param {String}        path   Where the file should be saved. It's the fullpath including filename with no extension.
  # @param {Array|Object}  size   It can be array of [w, h] or an object { size: [w, h], style: 'nocrop', blur: [10, 3] }
  #
  # @example
  #   server.methods.image.save ( stream, '/path/to/folder/filename_with_no_extension', [100, 50] )
  #   server.methods.image.save ( stream, '/path/to/folder/filename_with_no_extension', { size: [100, 50], style: 'nocrop' } )
  #
  server.method 'image.save', (file, path, size) ->
    ext  = get_ext file
    path = "#{path}#{ext}"
    opts = { size: [], style: 'crop' }
    if size instanceof Array
      opts.size = size
    else
      opts = size
    ensureDir = ->
      deferred = Q.defer()
      fs.ensureDir Path.dirname(path), (err)->
        deferred.resolve()
      deferred.promise
    
    Q.fcall( ensureDir ).then(
      (err) ->
        deferred = Q.defer()
        writeStream = fs.createWriteStream path
        writeStream.on 'finish', ->
          deferred.resolve(path)
        
        process = gm(file).resize opts.size[0], opts.size[1], '^'
        process.gravity('Center').crop opts.size[0], opts.size[1] if opts.style == 'crop'
        process.blur opts.blur[0], opts.blur[1] if opts.blur?
        process.stream().pipe writeStream
        deferred.promise
    )
  
  server.method 'image.delete', (path) ->
    Q.nfcall fs.unlink, path
  
  server.method 'image.replace', (source, destination) ->
    Q.nfcall(fs.copy, source, destination, replace:yes)
      .then ->
        Q.nfcall fs.unlink, source

  server.method 'image.rename', (from, to) ->
    Q.nfcall(fs.rename, from, to)
