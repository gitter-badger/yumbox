Joi = require 'joi'
moment = require 'moment'

module.exports = class validator
  
  app:
    create:
      params:
        user_key: Joi.string().required()
      payload:
        body: Joi.string().required()
    chats:
      query:
        page: Joi.number().integer().min(1).default(1)
    messages:
      params:
        chat_key: Joi.string().required()
      query:
        page: Joi.number().integer().min(1).default(1)

  dashboard:
    shoutout:
      payload:
        message: Joi.string().required()
