Joi = require 'joi'

module.exports = class Validator
  dashboard:
    signin:
      payload:
        username: Joi.string().required()
        password: Joi.string().required()
 
