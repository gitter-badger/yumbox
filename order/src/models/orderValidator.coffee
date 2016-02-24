Joi = require 'joi'

module.exports = class Validator
  
  create:
    payload:
      customer_key: Joi.string()
      daily_meal_key: Joi.string()
      quantity: Joi.number().min(1)
      at: Joi.string()
      status: Joi.number()
      price: Joi.number()
      isCanceled: Joi.boolean()
