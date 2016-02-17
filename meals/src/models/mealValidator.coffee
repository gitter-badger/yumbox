Joi = require 'joi'

module.exports = class validator
  
  mainDishCreate:
    payload:
      name: Joi.string().required()
      remained: Joi.number().required()
      total: Joi.number().required().min(1)
      price: Joi.number().min(10000).required(50000)
      calories: Joi.number().required()
      description: Joi.string().required()
      images: Joi.array().single().required()

  sideDishCreate:
    payload:
      name: Joi.string().required()
      images: Joi.array().single().required()
