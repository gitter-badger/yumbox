(function() {
  var Hapi, config, server;

  Hapi = require('hapi');

  server = new Hapi.Server;

  config = require(__dirname + "/config/config").config;

  require(__dirname + "/methods/model")(server, config);

  require(__dirname + "/methods/file")(server, config);

  require(__dirname + "/methods/json")(server);

  require(__dirname + "/decorators/reply")(server);

  module.exports = server;

}).call(this);
