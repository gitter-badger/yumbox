(function() {
  var Q, _;

  Q = require('q');

  _ = require('lodash');

  module.exports = function(server, options) {
    var MainDish;
    MainDish = require('../models/main_dish')(server, options);
    return {
      dashboard: {
        create: function(request, reply) {
          var main_dish;
          main_dish = new MainDish(request.payload);
          return main_dish.create(true).then(function(result) {
            return reply.success(result);
          });
        },
        toggle_availabilitty: function(request, reply) {
          var key;
          key = request.params.key;
          return MainDish.get(key).then(function(main_dish) {
            main_dish.doc.is_available = !main_dish.doc.is_available;
            return main_dish.update();
          }).then(function(result) {
            if (result instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.nice(result);
          });
        },
        detail: function(request, reply) {
          var key;
          key = request.params.key;
          return MainDish.get(key).then(function(main_dish) {
            if (main_dish instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.success(main_dish.mask());
          });
        },
        list_all: function(request, reply) {
          return MainDish.list_all().then(function(results) {
            if (results instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.nice(results);
          });
        },
        edit: function(request, reply) {
          var main_dish, main_dish_key, payload;
          payload = request.payload;
          main_dish_key = request.params.key;
          main_dish = new MainDish(main_dish_key, payload);
          return main_dish.update(true).then(function(result) {
            if (result instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.success(true, result);
          }).done();
        },
        remove: function(request, reply) {
          var main_dish_key;
          main_dish_key = request.params.key;
          return MainDish.remove(main_dish_key).then(function(result) {
            if (result instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.nice(result);
          });
        },
        add_photo: function(request, reply) {
          var main_dish_key;
          main_dish_key = request.params.key;
          return MainDish.get(main_dish_key).then(function(main_dish) {
            main_dish.doc.photo_files = request.payload.photo;
            return main_dish.update(true);
          }).then(function(result) {
            if (result instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.nice(result);
          });
        }
      }
    };
  };

}).call(this);
