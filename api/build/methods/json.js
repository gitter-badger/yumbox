(function() {
  var JsonMask;

  JsonMask = require('json-mask');

  module.exports = function(server) {
    return server.method('json.mask', function(data, mask) {
      return JsonMask(data, mask);
    });
  };

}).call(this);
