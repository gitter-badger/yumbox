(function() {
  var Boom, Q, UUID, bcrypt, moment,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  UUID = require('node-uuid');

  Q = require('q');

  moment = require('moment');

  Boom = require('boom');

  bcrypt = require('bcrypt');

  module.exports = function(server, options) {
    var HostelEmail;
    return HostelEmail = (function(superClass) {
      extend(HostelEmail, superClass);

      HostelEmail.prototype.PREFIX = 'he';

      HostelEmail.prototype.props = {
        hostel_key: true,
        verification: false,
        password: false,
        address: true
      };

      function HostelEmail(key, doc, all) {
        HostelEmail.__super__.constructor.call(this, this._key(key), doc, all);
      }

      HostelEmail.prototype.before_create = function() {
        return this._set_password().then((function(_this) {
          return function() {
            _this._set_verification();
            return _this._isValid();
          };
        })(this));
      };

      HostelEmail.prototype.check_password = function(password) {
        return Q.nfcall(bcrypt.compare, password, this.doc.password).then(function(result) {
          return result;
        });
      };

      HostelEmail.prototype.change_password = function(current_password, new_password) {
        return this.check_password(current_password).then((function(_this) {
          return function(is_pass_valid) {
            if (!is_pass_valid) {
              return new Error("Old password doesn't match");
            }
            _this.password = new_password;
            return _this._set_password().then(function() {
              return _this.update();
            });
          };
        })(this));
      };

      HostelEmail.get_by_email = function(email, raw) {
        if (raw == null) {
          raw = false;
        }
        return this.get(this.prototype._key(email), raw);
      };

      HostelEmail.prototype._key = function(email) {
        return (HostelEmail.prototype.PREFIX + ":" + email).toLowerCase();
      };

      HostelEmail.prototype._set_password = function() {
        return Q.nfcall(bcrypt.genSalt, 10).then((function(_this) {
          return function(salt) {
            return Q.nfcall(bcrypt.hash, _this.password, salt);
          };
        })(this)).then((function(_this) {
          return function(result) {
            _this.doc.password = result;
            return delete _this.password;
          };
        })(this));
      };

      HostelEmail.prototype._set_verification = function() {
        return this.doc.verification = {
          code: UUID.v4(),
          expires_at: moment().add(options.defaults.email_verification_expiry_due, 'day').format(),
          verified_at: null
        };
      };

      HostelEmail.prototype._isValid = function() {
        return HostelEmail.get(this.key).then((function(_this) {
          return function(data) {
            if (data instanceof Error) {
              return true;
            }
            return Boom.conflict('Email is already taken');
          };
        })(this));
      };

      return HostelEmail;

    })(server.methods.model.Base());
  };

}).call(this);
