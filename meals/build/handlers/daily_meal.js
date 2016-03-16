(function() {
  var Q, _, mask;

  Q = require('q');

  _ = require('lodash');

  mask = require('json-mask');

  module.exports = function(server, options) {
    var DailyMeal, MainDish, SideDish;
    DailyMeal = require('../models/daily_meal')(server, options);
    MainDish = require('../models/main_dish')(server, options);
    SideDish = require('../models/side_dish')(server, options);
    return {
      app: {
        feed: function(request, reply) {
          var feed, promises;
          feed = [];
          promises = [];
          return DailyMeal.get_upcomings().then(function(results) {
            _.each(results, function(result) {
              return promises.push(Q.fcall((function(_this) {
                return function() {
                  return MainDish.find(result.main_dish_key).then(function(main_dish) {
                    return result.main_dish = main_dish;
                  }).then(function() {
                    return SideDish.find(result.side_dish_keys, "name,doc_key");
                  }).then(function(side_dishes) {
                    return result.side_dishes = side_dishes;
                  }).then(function() {
                    return mask(result, "doc_key,total,main_dish,side_dishes,remained");
                  });
                };
              })(this)));
            });
            return Q.all(promises).then(function(result) {
              return reply.nice(result);
            });
          });
        }
      },
      dashboard: {
        create: function(request, reply) {
          var daily_meal;
          daily_meal = new DailyMeal(request.payload);
          return daily_meal.create(true).then(function(result) {
            return reply.success(result);
          });
        },
        get_detail: function(request, reply) {
          var key;
          key = request.params.key;
          return DailyMeal.get(key).then(function(meal) {
            var main_dish_key, side_dishes_key;
            main_dish_key = meal.doc.main_dish;
            side_dishes_key = meal.doc.side_dishes;
            return SideDish.find(side_dishes_key).then(function(sidedishes) {
              return MainDish.find(main_dish_key).then(function(maindish) {
                meal.doc.main_dish = maindish;
                meal.doc.side_dishes = sidedishes;
                return reply(meal.doc);
              });
            });
          });
        },
        edit: function(request, reply) {
          var daily_meal, daily_meal_key, payload;
          payload = request.payload;
          daily_meal_key = request.params.key;
          daily_meal = new DailyMeal(daily_meal_key, payload);
          return daily_meal.update(true).then(function(result) {
            if (result instanceof Error) {
              return reply.Boom.badImplementation("something's wrong");
            }
            return reply.success(true, result);
          }).done();
        },
        remove: function(request, reply) {
          var daily_meal_key;
          daily_meal_key = request.params.key;
          return DailyMeal.remove(daily_meal_key).then(function(result) {
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
