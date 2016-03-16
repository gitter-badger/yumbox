(function() {
  module.exports = function(server, options) {
    return {
      list: function(request, reply) {
        return reply.nice('Hello!!!');
      }
    };
  };

}).call(this);
