Joi = require 'joi'

module.exports = class MainDishValidator
  
  create:
    payload:
      name: Joi.string().required()
      price: Joi.number().required()
      contains: Joi.string()
      description: Joi.string()
      calories: Joi.number()

  edit:
    payload:
      name: Joi.string()
      price: Joi.number()
      contains: Joi.string()
      description: Joi.string()
      calories: Joi.number()
    params:
      key: Joi.string()

  add_photo:
    payload:
      photo: Joi.array().items(
        Joi.object().unknown().keys({
          hapi: Joi.object().unknown().keys({
            headers: Joi.object().unknown().keys(
              { 'content-type' : 'photo/jpeg' })
          })
        })
      ).single()


