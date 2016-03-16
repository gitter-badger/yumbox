Joi = require 'joi'
moment = require 'moment'

module.exports = class DailyMealValidator
  create:
    payload:
      main_dish_key: Joi.string().required()
      side_dish_keys: Joi.array().items(Joi.string().required())
      at: Joi.date().format('YYYY-MM-DD').min(moment().add(-1, 'd').format()).required()
      total: Joi.number().required()

  get_detail:
    params:
      key: Joi.string().required()
    
    payload:
      main_dish_key: Joi.string()
      side_dishe_keys: Joi.array().items(Joi.string()).required()
      at: Joi.date().iso().min('now')
      total: Joi.number()
