Joi = require 'joi'

module.exports = class MainDishValidator
  
  create:
    payload:
      name: Joi.string().required()
      price: Joi.number().required()
      contains: Joi.string().required()
      description: Joi.string().required()
      calories: Joi.number().required()

  get:{}
  
  detail:
    params:
      key: Joi.string().required()
    query: {}

  toggle:
    params:
      key: Joi.string().required()
    query: {}

  edit:
    payload:
      name: Joi.string()
      price: Joi.number()
      contains: Joi.string()
      description: Joi.string()
      calories: Joi.number()

    params:
      key: Joi.string()
    query: {}

  delete:
    params:
      key: Joi.string().required()
    query: {}

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
    query: {}
