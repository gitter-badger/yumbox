Joi = require 'joi'
moment = require 'moment'

module.exports = class OrderValidator
  
  create:
    payload:
      customer_key: Joi.string()
      daily_meal_key: Joi.string().required
      quantity: Joi.number().min(1).required
      at: Joi.date().min(moment().format()).required()
      status: Joi.number()
      price: Joi.number()
      isCanceled: Joi.boolean()

  get_detail:
    payload:
      customer_key: Joi.string()
      daily_meal_key: Joi.string()
      quantity: Joi.number()
      at: Joi.date().min(moment().format()).required()
      status: Joi.number()
      price: Joi.number()
      isCanceled: Joi.boolean()

    params:
      key: Joi.string().required()
