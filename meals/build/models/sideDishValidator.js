(function() {
  var Joi, Validator;

  Joi = require('joi');

  module.exports = Validator = (function() {
    function Validator() {}

    Validator.prototype.create = {
      payload: {
        name: Joi.string(),
        remained: Joi.number(),
        total: Joi.number().min(1),
        price: Joi.number(),
        calories: Joi.number(),
        description: Joi.string(),
        images: Joi.array()
      }
    };

    Validator.prototype.add_images = {
      payload: {
        images: Joi.array().items(Joi.object().unknown().keys({
          hapi: Joi.object().unknown().keys({
            headers: Joi.object().unknown().keys({
              'content-type': 'image/jpeg'
            })
          })
        })).single()
      }
    };

    return Validator;

  })();

}).call(this);
