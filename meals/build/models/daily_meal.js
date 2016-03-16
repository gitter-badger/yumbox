(function() {
  var Boom, Q, ShortID, _, moment,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Boom = require('boom');

  _ = require('lodash');

  Q = require('q');

  ShortID = require('shortid');

  moment = require('moment');

  module.exports = function(server, options) {
    var DailyMeal;
    return DailyMeal = (function(superClass) {
      extend(DailyMeal, superClass);

      function DailyMeal() {
        return DailyMeal.__super__.constructor.apply(this, arguments);
      }

      DailyMeal.prototype.PREFIX = 'd';

      DailyMeal.prototype.props = {
        main_dish_key: true,
        side_dish_keys: true,
        at: true,
        total: true,
        remained: true
      };

      DailyMeal.prototype._mask = 'main_dish,side_dishes,at,total,doc_key';

      DailyMeal.get_upcomings = function() {
        var query;
        query = {
          body: {
            size: 3,
            query: {
              filtered: {
                query: {
                  match_all: {}
                },
                filter: {
                  range: {
                    at: {
                      gte: moment().format('YYYY-MM-DD'),
                      lte: moment().add(3, 'd').format('YYYY-MM-DD')
                    }
                  }
                }
              }
            }
          }
        };
        return this.search('daily_meal', query).then((function(_this) {
          return function(daily_meals) {
            var ids;
            if (daily_meals.hits.total < 1) {
              return Q;
            }
            ids = [];
            _.each(daily_meals.hits.hits, function(daily_meal) {
              return ids.push(daily_meal._id);
            });
            return _this.find(ids, true);
          };
        })(this));
      };

      return DailyMeal;

    })(server.methods.model.Base());
  };

}).call(this);
