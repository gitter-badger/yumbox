(function() {
  var Boom, Q, _;

  Q = require('q');

  _ = require('lodash');

  Boom = require('boom');

  module.exports = function(server, options) {
    var SideDish;
    SideDish = require('../models/side_dish')(server, options);
    return {
      dashboard: {
        create: function(request, reply) {
          var side_dish;
          side_dish = new SideDish(request.payload);
          return side_dish.create(true).then(function(result) {
            return reply.success(result);
          });
        },
        edit: function(request, reply) {
          var payload, side_dish, side_dish_key;
          payload = request.payload;
          side_dish_key = request.params.key;
          side_dish = new SideDish(side_dish_key, payload);
          return side_dish.update(true).then(function(result) {
            if (result instanceof Error) {
              return reply.Boom.badImplementation("something's wrong");
            }
            return reply.success(true, result);
          }).done();
        },
        remove: function(request, reply) {
          var side_dish_key;
          side_dish_key = request.params.key;
          return SideDish.remove(side_dish_key).then(function(result) {
            if (result instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.nice(result);
          });
        },
        add_photo: function(request, reply) {
          var side_dish_key;
          side_dish_key = request.params.key;
          return SideDish.get(side_dish_key).then(function(side_dish) {
            side_dish.photo = request.payload.photo;
            return side_dish.update(true);
          }).then(function(result) {
            if (result instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.nice(result);
          });
        },
        toggle_availabilitty: function(request, reply) {
          var key;
          key = request.params.key;
          return SideDish.get(key).then(function(side_dish) {
            side_dish.doc.is_available = !side_dish.doc.is_available;
            return side_dish.update();
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
          return SideDish.get(key).then(function(side_dish) {
            if (side_dish instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.nice(side_dish.mask());
          });
        },
        list_all: function(request, reply) {
          return SideDish.list_all().then(function(results) {
            if (results instanceof Error) {
              return reply(Boom.badImplementation("something's wrong"));
            }
            return reply.nice(results);
          });
        }
      }
    };
  };

}).call(this);
