Joi = require 'joi'
moment = require 'moment'

module.exports = class DailyMealValidator

  edit:
    payload:
      main_dish_key: Joi.string()
      side_dish_keys: Joi.array().items(Joi.string())
      at: Joi.date().format('YYYY-MM-DD').min(moment().add(-1, 'd').format()).required()
      total: Joi.number().required()

    params:
      key: Joi.string()

    query: {}

  create:
    payload:
      main_dish_key: Joi.string().required()
      side_dish_keys: Joi.array().items(Joi.string().required())
      at: Joi.date().format('YYYY-MM-DD').min(moment().add(-1, 'd').format()).required()
      total: Joi.number().required()

  detail:
    params:
      key: Joi.string().required()
    
    query: {}
    
  get: {}

  delete:
    params:
      key: Joi.string()
    query: {}


