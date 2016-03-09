Joi = require 'joi'

module.exports = class validator
  
  create:
    payload:
      device_id: Joi.string().required()
      version: Joi.string().required()
      device: Joi.string().required()
      location: Joi.object().keys(
        latitude: Joi.number()
        longitude: Joi.number()
      )

  login:
    payload:
      device_id: Joi.string()
      phone: Joi.string()
      auth: Joi.string().required()
      version: Joi.string().required()
      device: Joi.string().required()
      location: Joi.object().keys(
        latitude: Joi.number()
        longitude: Joi.number()
      )

  phone:
    payload:
      phone: Joi.string().required()

  verify:
    payload:
      pin: Joi.number().required()
