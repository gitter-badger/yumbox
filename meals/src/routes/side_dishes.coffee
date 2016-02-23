SideDishValidator = require '../models/sideDishValidator'

module.exports = (server, options) ->

  SideDish = require('../handlers/side_dishes') server, options
 
  return [
    {
      method: 'POST'
      path: '/v1/dashboard/side_dishes'
      config:
        handler: SideDish.dashboard.create
        payload:
          output: 'stream'
        description: 'Create a side meal.'
        tags: ['meal','dashboard','side_dish', 'create']
    }
    {
      method: 'PUT'
      path: '/v1/dashboard/side_dishes/{key}'
      config:
        handler: SideDish.dashboard.edit
        validate: SideDishValidator::edit
        description: 'Updates sidedish'
        tags: ['side_dish', 'update','edit']
    }
    {
      method: 'DELETE'
      path: '/v1/dashboard/side_dishes/{key}'
      config:
        handler: SideDish.dashboard.remove
        description: 'remove a side dish'
        tags: ['meal','dashboard','side_dish', 'delete']
    }
    {
      method: 'POST'
      path: '/v1/dashboard/side_dishes/{key}/images'
      config:
        handler: SideDish.dashboard.add_images
        payload:
          output: 'stream'
        #validate: SideDish Validator::add_images
        description: 'adds some images to side dish'
        tags: ['side_dish', 'image']
    }

  ]
