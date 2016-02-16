Model = require('odme').CB
es    = require 'elasticsearch'
Path  = require 'path'

module.exports = (server, config) ->

  if config.databases.application.mock
    db = new require("puffer") { }, true
  else
    db = require('puffer').instances[config.databases.application.name]

  class Base extends Model
    source:  db

    # ## get directory path
    #
    # Get directory path by class name. Generally you don't need this and you should use `save_image` or `get_full_path`.
    #
    # @method
    # @public
    #
    # @param {String}        name   optional name to add after class name
    #
    # @example
    #   class User extends Base
    #   user = new User
    #   user.get_path('avatar') # /www/tipi/shared/user/avatar
    #
    get_path: (name='') ->
      Path.join "#{server.methods.file.root()}/#{@constructor.name.toLowerCase()}/", name

    # ## get file path
    #
    # Get file path by class name and using optional name at the end. It's better to pass this optional name, otherwise the last part of `get_path` will be your file name.
    #
    # @method
    # @public
    #
    # @param {String}        name   optional name to use as file name
    #
    # @example
    #   class User extends Base
    #   user = new User
    #   user.get_full_path('medium') # /www/tipi/shared/user/u_/Ny/Wu/2K/04/medium
    #
    get_full_path: (name='')->
      Path.join @get_path(), server.methods.file.safe_path(@key), name

    # ## save file in a path
    #
    # Save file in a path based on combination of class name, object key and passed name as filename. 
    #
    # @method
    # @public
    #
    # @param {File|String}   file     file object or original file path.
    # @param {String}        name     destination file name
    # @param {Array|Object}  options  same as `methods.image.save` options
    #
    # @example
    #   class User extends Base
    #   user = new User
    #   user.save_image file, 'small_avatar', [400,400]
    #
    save_image: (file, name, options) ->
      server.methods.image.save(file, @get_full_path(name), options)

    delete_image: (name) ->
      path = @get_full_path name
      server.methods.image.delete path

    replace_image: (source, destination) ->
      source_path = @get_full_path source
      destination_path = @get_full_path destination
      server.methods.image.replace source_path, destination_path

    rename_image: (from, to) ->
      from_path = @get_full_path from
      to_path = @get_full_path to
      server.methods.image.rename from_path, to_path

    @get_base_key: (key)->
      key.split(":")[0]

    get_base_key: (key)->
      Base.get_base_key key

    @search: (type, query)->
      client = new es.Client
        host: "#{config.searchengine.host}:#{config.searchengine.port}"
        log: config.searchengine.log

      query.index = config.searchengine.name
      query.type = type
      client.search query

  server.method 'model.Base', ->
    Base
