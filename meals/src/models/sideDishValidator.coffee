Joi = require 'joi'

module.exports = class Validator
  
  create:
    payload:
      name: Joi.string().required()

    query: {}

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


