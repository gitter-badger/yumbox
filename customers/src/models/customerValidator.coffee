Joi = require 'joi'

module.exports = class validator
  app:
    verify_pin:
      payload:
        mobile: Joi.string().required()
        pin: Joi.number().required()
 
