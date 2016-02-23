MainDishValidator = require '../models/mainDishValidator'

module.exports = (server, options) ->

  MainDish = require('../handlers/main_dish') server, options
 
  return [
    {
      method: 'POST'
      path: '/v1/dashboard/main_dish'
      config:
        handler: MainDish.dashboard.create
        payload:
          output: 'stream'
        description: 'Create a main meal.'
        tags: ['meal','dashboard','main_dish', 'create']
    }
    {
      method: 'PUT'
      path: '/v1/dashboard/main_dish/{key}'
      config:
        handler: MainDish.dashboard.edit
        validate: MainDishValidator::edit
        description: 'Updates maindish'
        tags: ['main_dish', 'update','edit']
    }
    {
      method: 'DELETE'
      path: '/v1/dashboard/main_dish/{key}'
      config:
        handler: MainDish.dashboard.remove
        payload:
          output: 'stream'
        description: 'remove a main dish'
        tags: ['meal','dashboard','main_dish', 'delete']
    }
    {
      method: 'POST'
      path: '/v1/dashboard/images'
      config:
        handler: MainDish.dashboard.add_images
        payload:
          output: 'stream'
      #  validate: MainDishValidator::add_images
        description: 'adds some images to main dish'
        tags: ['main_dish', 'image']
    }

  ]
