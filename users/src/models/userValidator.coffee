Joi = require 'joi'
moment = require 'moment'

module.exports = class validator
  
  interests = [
    "adrenalin_junky"
    "chatter_box"
    "couch_potato"
    "culture_vulture"
    "deal_king"
    "eco_warrior"
    "flashpacker"
    "jetsetter"
    "last_minuter"
    "happy_hippy"
    "party_animal"
    "wifi_hunter"
  ]

  admin:
    list:
      query:
        from: Joi.number().integer().default(0)
        login_counts: Joi.number().integer()
  app:
    create:
      payload:
        email: Joi.string().email().required()
        name: Joi.string().required()
        avatar: Joi.object().required()
        city: Joi.string()
        country: Joi.string()
        gender: Joi.number().greater(-1).less(2).integer()
        version: Joi.string().required()
        device: Joi.string().required()
        last_location: Joi.object().keys(
          latitude: Joi.number()
          longitude: Joi.number()
          )

        interests: Joi.array().length(4).sparse(off).items(Joi.string().valid(interests)).unique()

        passport:Joi.object().keys(
          number: Joi.string()
          expires_at: Joi.date().iso().min('now')
          scan: Joi.object())

        fb_token:Joi.string()
        g_token:Joi.string()
        insurance_dismissed_at: Joi.date().iso().max('now')
        dob: Joi.date().max('now')

    login:
      payload:
        email: Joi.string().required()
        auth: Joi.string().required()
        version: Joi.string().required()
        device: Joi.string().required()
        last_location: Joi.object().keys(
          latitude: Joi.number()
          longitude: Joi.number()
          )

    edit:
      payload:
        email: Joi.string().email()
        name: Joi.string()
        avatar: Joi.object()
        city: Joi.string()
        country: Joi.string()
        gender: Joi.number().greater(-1).less(2).integer()
        passport:Joi.object().keys(
          number: Joi.string()
          expires_at: Joi.date().iso().min('now')
          scan: Joi.object())

        fb_token:Joi.string()
        g_token:Joi.string()
        insurance_dismissed_at: Joi.date().iso().max('now')
        dob: Joi.date().max('now')

    update_interests:
      payload:
        interests: Joi.array().length(4).sparse(off).items(Joi.string().valid(interests)).unique()
    show:
      params:
        user_key: Joi.string().required()
    
    generate_pin:
      payload:
        email: Joi.string().email().required()

    verify_pin:
      payload:
        email: Joi.string().email().required()
        pin: Joi.number().required()

  dashboard:
    create:
      payload:
        email: Joi.string().email().required()
        name: Joi.string().required()
        avatar: Joi.object().required()
        city: Joi.string()
        country: Joi.string()
        gender: Joi.number().greater(-1).less(2).integer()

        passport:Joi.object().keys(
          number: Joi.string()
          expires_at: Joi.date().iso().min('now')
          scan: Joi.object())

        dob: Joi.date().max('now')
        
        booking:
          reference_number: Joi.string()
          from: Joi.date().min(moment().subtract(1, 'day').format('YYYY-MM-DD')).format('YYYY-MM-DD').required()
          to: Joi.date().min(Joi.ref 'from').format('YYYY-MM-DD').required()

    claim:
      params:
        user_key: Joi.string().required()
      payload:
        email: Joi.string().email().required()
        booking:
          reference_number: Joi.string()
          from: Joi.date().min(moment().subtract(1, 'day').format('YYYY-MM-DD')).format('YYYY-MM-DD').required()
          to: Joi.date().min(Joi.ref 'from').format('YYYY-MM-DD').required()

    confirm_passport:
      params:
        user_key: Joi.string().required()
      payload:
        confirmed: Joi.boolean().required()
