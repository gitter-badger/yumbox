(function() {
  var Model, Path, es,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Model = require('odme').CB;

  es = require('elasticsearch');

  Path = require('path');

  module.exports = function(server, config) {
    var Base, db;
    if (config.databases.application.mock) {
      db = new require("puffer")({}, true);
    } else {
      db = require('puffer').instances[config.databases.application.name];
    }
    Base = (function(superClass) {
      extend(Base, superClass);

      function Base() {
        return Base.__super__.constructor.apply(this, arguments);
      }

      Base.prototype.source = db;

      Base.prototype.get_path = function(name) {
        if (name == null) {
          name = '';
        }
        return Path.join((server.methods.file.root()) + "/" + (this.constructor.name.toLowerCase()) + "/", name);
      };

      Base.prototype.get_full_path = function(name) {
        if (name == null) {
          name = '';
        }
        return Path.join(this.get_path(), server.methods.file.safe_path(this.key), name);
      };

      Base.prototype.save_image = function(file, name, options) {
        return server.methods.image.save(file, this.get_full_path(name), options);
      };

      Base.prototype.delete_image = function(name) {
        var path;
        path = this.get_full_path(name);
        return server.methods.image["delete"](path);
      };

      Base.prototype.replace_image = function(source, destination) {
        var destination_path, source_path;
        source_path = this.get_full_path(source);
        destination_path = this.get_full_path(destination);
        return server.methods.image.replace(source_path, destination_path);
      };

      Base.prototype.rename_image = function(from, to) {
        var from_path, to_path;
        from_path = this.get_full_path(from);
        to_path = this.get_full_path(to);
        return server.methods.image.rename(from_path, to_path);
      };

      Base.get_base_key = function(key) {
        return key.split(":")[0];
      };

      Base.prototype.get_base_key = function(key) {
        return Base.get_base_key(key);
      };

      Base.search = function(type, query) {
        var client;
        client = new es.Client({
          host: config.searchengine.host + ":" + config.searchengine.port,
          log: config.searchengine.log
        });
        query.index = config.searchengine.name;
        query.type = type;
        return client.search(query);
      };

      return Base;

    })(Model);
    return server.method('model.Base', function() {
      return Base;
    });
  };

}).call(this);
