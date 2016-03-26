Joi = require 'joi'

module.exports = class validator
  app:
    verify_pin:
      payload:
        mobile: Joi.string().required()
        pin: Joi.number().required()
     
    sign_up:
      payload:
        name: Joi.string().required()
        mobile: Joi.string().required()
        address: Joi.string().required()
    
      params: {}
      query: {}

    request_verification_pin:
      payload:
        mobile: Joi.string()
      params: {}
      query: {}

    
