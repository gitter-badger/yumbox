Joi = require 'joi'

module.exports = class validator
  
  main_dish:
    create:
      payload:
        name: Joi.string()
        remained: Joi.number()
        total: Joi.number().min(1)
        price: Joi.number()
        calories: Joi.number()
        description: Joi.string()
        images: Joi.array()
