(function() {
  var Boom;

  Boom = require('boom');

  module.exports = function(server) {
    server.decorate('reply', 'nice', function(data) {
      return this.response({
        data: data,
        error: null
      });
    });
    server.decorate('reply', 'success', function(bool, data) {
      if (data == null) {
        data = null;
      }
      if (data == null) {
        return this.nice({
          success: bool
        });
      }
      data.success = bool;
      return this.nice(data);
    });
    server.decorate('reply', 'conflict', function(message) {
      return this.response(Boom.conflict(message));
    });
    server.decorate('reply', 'not_found', function(message) {
      return this.response(Boom.notFound(message));
    });
    return server.decorate('reply', 'mask', function(data, mask) {
      return this.nice(server.methods.json.mask(data, mask));
    });
  };

}).call(this);
