MainDishValidator = require '../models/mainDishValidator'

module.exports = (server, options) ->

  Meal = require('../handlers/meal') server, options
 
  return [
    {
      method: 'POST'
      path: '/v1/dashboard/main_dish'
      config:
        handler: Meal.dashboard.main_dish.create
        validate: MainDishValidator::create
        payload:
          output: 'stream'
        description: 'Create a main meal.'
        tags: ['meal','dashboard','main_dish']
    }
    {
      method: 'POST'
      path: '/v1/dashboard/me/images'
      config:
        pre:[
          {
            method: Meal.dashboard.pre.get_my_main_dish_key
            assign: 'my_main_dish_key'
          }
        ]
        handler: Meal.dashboard.add_images
        payload:
          output: 'stream'
        validate: MainDishValidator::add_images
        auth: 'session'
        description: 'adds some images to meals profile'
        tags: ['meal', 'image']
    }
    {
      method: 'DELETE'
      path: '/v1/dashboard/me/images/{image_name}'
      config:
        pre:[
          {
            method: Meal.dashboard.pre.get_my_main_dish_key
            assign: 'my_main_dish_key'
          }
        ]
        handler: Meal.dashboard.remove_image
        validate: MainDishValidator::remove_image
        auth: 'session'
        description: 'main_dish removes an image of an activity'
        tags: ['main_dish', 'image']
    }
    {
      method: 'POST'
      path: '/v1/dashboard/me/images/{image_name}/main'
      config:
        pre:[
          {
            method: Meal.dashboard.pre.get_my_main_dish_key
            assign: 'my_main_dish_key'
          }
        ]
        handler:  Meal.dashboard.set_main_image
        validate: MainDishValidator::set_main_image
        auth: 'session'
        description: 'main_dish removes an image of an activity'
        tags: ['main_dish', 'image']
    }
 

  ]
