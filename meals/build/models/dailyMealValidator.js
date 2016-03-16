(function() {
  var DailyMealValidator, Joi, moment;

  Joi = require('joi');

  moment = require('moment');

  module.exports = DailyMealValidator = (function() {
    function DailyMealValidator() {}

    DailyMealValidator.prototype.create = {
      payload: {
        main_dish_key: Joi.string().required(),
        side_dish_keys: Joi.array().items(Joi.string().required()),
        at: Joi.date().format('YYYY-MM-DD').min(moment().add(-1, 'd').format()),
        total: Joi.number().required()
      }
    };

    DailyMealValidator.prototype.get_detail = {
      params: {
        key: Joi.string().required()
      },
      payload: {
        main_dish_key: Joi.string(),
        side_dishe_keys: Joi.array().items(Joi.string()).required(),
        at: Joi.date().iso().min('now'),
        total: Joi.number()
      }
    };

    return DailyMealValidator;

  })();

}).call(this);
