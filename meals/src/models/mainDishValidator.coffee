Joi = require 'joi'

module.exports = class validator
  
    create:
      payload:
        name: Joi.string()
        remained: Joi.number()
        total: Joi.number().min(1)
        price: Joi.number()
        calories: Joi.number()
        description: Joi.string()
        images: Joi.array()

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


