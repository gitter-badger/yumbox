(function() {
  module.exports = function(plugin, options, next) {
    var server;
    server = plugin.select('api');
    server.route(require('./routes/main_dishes')(server, options));
    server.route(require('./routes/side_dishes')(server, options));
    server.route(require('./routes/daily_meal')(server, options));
    return next();
  };

}).call(this);
