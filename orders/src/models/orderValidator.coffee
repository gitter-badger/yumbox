Joi = require 'joi'

module.exports = class Validator
  
  create:
    payload:
      customer_key: Joi.string()
      daily_meal_key: Joi.string().required
      quantity: Joi.number().min(1).required
      at: Joi.string()
      status: Joi.number()
      price: Joi.number()
      isCanceled: Joi.boolean()
