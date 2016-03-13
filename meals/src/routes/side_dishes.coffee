SideDishValidator = require '../models/sideDishValidator'

module.exports = (server, options) ->

  SideDish = require('../handlers/side_dishes') server, options
 
  return [
    {
      method: 'GET'
      path: "/v1/dashboard/side_dishes/{key}"
      config:
        handler: SideDish.dashboard.detail
        description: 'get details of a side dish'
        tags: ['meal','dashboard','side_dish', 'detail']
    }
    {
      method: 'GET'
      path: '/v1/dashboard/side_dishes'
      config:
        handler: SideDish.dashboard.list_all
        description: 'List all available side dishes.'
        tags: ['meal','dashboard','side_dish', 'list']
    }
    {
      method: 'POST'
      path: '/v1/dashboard/side_dishes'
      config:
        handler: SideDish.dashboard.create
        payload:
          output: 'stream'
        description: 'Create a side dish.'
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
      method: 'PUT'
      path: '/v1/dashboard/side_dishes/{key}/toggle'
      config:
        handler: SideDish.dashboard.toggle_availabilitty
        description: 'toggle sidedish availability'
        tags: ['side_dish', 'update','toggle','unavailable', 'available']
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
      path: '/v1/dashboard/side_dishes/{key}/photo'
      config:
        handler: SideDish.dashboard.add_photo
        payload:
          output: 'stream'
        description: 'add a photo to side dish'
        tags: ['meal','dashboard','side_dish', 'photo']
    }
  ]
