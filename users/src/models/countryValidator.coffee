Joi = require 'joi'

module.exports = class validator

  suggest:
    query:
      q: Joi.string().required()
 
  create:
    payload:
      name: Joi.string().required()
      cities: Joi.array().items(Joi.string()).unique().required()
