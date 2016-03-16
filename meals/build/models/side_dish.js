(function() {
  var Boom, Q, ShortID, _,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Boom = require('boom');

  _ = require('lodash');

  Q = require('q');

  ShortID = require('shortid');

  module.exports = function(server, options) {
    var SideDish;
    return SideDish = (function(superClass) {
      extend(SideDish, superClass);

      SideDish.prototype.PREFIX = 's';

      SideDish.prototype.PHOTO = {
        SMALL: "small",
        MEDIUM: "medium"
      };

      SideDish.prototype.PHOTO_SIZE = {
        SMALL: [100, 100],
        MEDIUM: [500, 500]
      };

      SideDish.prototype.props = {
        name: true,
        photo: true,
        is_available: false
      };

      SideDish.prototype._mask = 'doc_key,name,is_available';

      function SideDish(key, doc, all) {
        SideDish.__super__.constructor.apply(this, arguments);
        if ((doc == null) && key instanceof Object) {
          doc = key;
        }
        if (doc.photo != null) {
          this.photo = doc.photo;
        }
        this.doc.is_available = false;
      }

      SideDish.prototype.before_save = function() {
        delete this.doc.photo;
        return true;
      };

      SideDish.prototype.after_save = function(data) {
        if (data instanceof Error) {
          return data;
        }
        return this._save_photo().then(function() {
          return data;
        });
      };

      SideDish.list_all = function() {
        var query;
        query = {
          body: {
            size: 1000,
            query: {
              match: {
                "doc.is_available": true
              }
            }
          }
        };
        return this.search('side_dish', query).then(function(results) {
          var ids;
          ids = [];
          _.each(results.hits.hits, function(result) {
            return ids.push(result._id);
          });
          return SideDish.find(ids, 'doc_key,name');
        });
      };

      SideDish.prototype._save_photo = function() {
        if (this.photo == null) {
          return Q();
        }
        return this.save_image(this.photo, SideDish.prototype.PHOTO.SMALL, SideDish.prototype.PHOTO_SIZE.SMALL).then((function(_this) {
          return function(saved_file_path) {
            return _this.save_image(saved_file_path, SideDish.prototype.PHOTO.MEDIUM, SideDish.prototype.PHOTO_SIZE.MEDIUM);
          };
        })(this));
      };

      return SideDish;

    })(server.methods.model.Base());
  };

}).call(this);
