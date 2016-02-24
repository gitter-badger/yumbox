Joi = require 'joi'

module.exports = class Validator
  
  create:
    payload:
      name: Joi.string().min(2).required()
      price: Joi.number().required()
      contains: Joi.string().min(2).required()
      description: Joi.string().min(2).required()
      calories: Joi.number().required()

  edit:
    payload:
      name: Joi.string().min(1)
      description: Joi.string().min(1)
 


  add_images:
    payload:
      images: Joi.array().items(
        Joi.object().unknown().keys({
          hapi: Joi.object().unknown().keys({
            headers: Joi.object().unknown().keys(
              { 'content-type' : 'image/jpeg' })
          })
        })
      ).single()


