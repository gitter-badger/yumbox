(function() {
  module.exports = function(server) {
    var analytics, api, config, db, defaults, settings, web;
    settings = require("./config");
    config = settings.config;
    defaults = settings.defaults;
    db = require('puffer').instances[config.databases.application.name];
    analytics = require('puffer').instances[config.databases.analytics.name];
    api = server.select('api');
    web = server.select('web');
    server.register([
      {
        register: require('hapi-auth-cookie')
      }, {
        register: require('vision')
      }, {
        register: require('inert')
      }, {
        register: require('lout')
      }, {
        register: require("good"),
        options: {
          reporters: [
            {
              reporter: require('good-console'),
              events: {
                log: '*',
                response: '*'
              }
            }
          ]
        }
      }
    ], function(err) {
      if (err) {
        throw err;
      }
      return server.auth.strategy('session', 'cookie', {
        password: 'secret',
        isSecure: false
      });
    });
    server.register([
      {
        register: require('hapi-io'),
        options: {
          auth: {
            mode: 'try',
            strategy: 'session'
          },
          connectionLabel: 'api'
        }
      }
    ], function(err) {
      if (err) {
        throw err;
      }
    });
    server.select(['web', 'api']).register([
      {
        register: require('yumbox.meals'),
        options: {
          database: db
        }
      }
    ], function(err) {
      if (err) {
        throw err;
      }
    });
    return server.start(function() {
      console.info('API server started at ' + server.select('api').info.uri);
      return console.info('Web server started at ' + server.select('web').info.uri);
    });
  };

}).call(this);
