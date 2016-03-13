Joi = require 'joi'
moment = require 'moment'

module.exports = class DailyMealValidator
  create:
    payload:
      main_dish: Joi.string().required()
      side_dishes: Joi.array().items(Joi.string().required())
      at: Joi.date().iso().min('now')
      total: Joi.number().required()

  get_detail:
    params:
      key: Joi.string().required()
    
    payload:
      main_dish: Joi.string()
      side_dishes: Joi.array().items(Joi.string()).required()
      at: Joi.date().iso().min('now')
      total: Joi.number()