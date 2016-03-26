SideDishValidator = require '../models/sideDishValidator'

module.exports = (server, options) ->

  SideDish = require('../handlers/side_dishes') server, options
 
  return [
    {
      method: 'GET'
      path: "/v1/dashboard/side_dishes/{key}"
      config:
        handler: SideDish.dashboard.detail
        validate: SideDishValidator::detail
        description: 'get details of a side dish'
        auth: 'jwt'
        tags: ['meal','dashboard','side_dish', 'detail']
    }
    {
      method: 'GET'
      path: '/v1/dashboard/side_dishes'
      config:
        handler: SideDish.dashboard.list_all
        validate: SideDishValidator::get
        description: 'List all available side dishes.'
        auth: 'jwt'
        tags: ['meal','dashboard','side_dish', 'list']
    }
    {
      method: 'POST'
      path: '/v1/dashboard/side_dishes'
      config:
        handler: SideDish.dashboard.create
        validate: SideDishValidator::create
        payload:
          output: 'stream'
        description: 'Create a side dish.'
        auth: 'jwt'
        tags: ['meal','dashboard','side_dish', 'create']
    }
    {
      method: 'PUT'
      path: '/v1/dashboard/side_dishes/{key}'
      config:
        handler: SideDish.dashboard.edit
        validate: SideDishValidator::edit
        description: 'Updates sidedish'
        auth: 'jwt'
        tags: ['side_dish', 'update','edit']
    }
    {
      method: 'PUT'
      path: '/v1/dashboard/side_dishes/{key}/toggle'
      config:
        handler: SideDish.dashboard.toggle_availabilitty
        validate: SideDishValidator::toggle
        description: 'toggle sidedish availability'
        auth: 'jwt'
        tags: ['side_dish', 'update','toggle','unavailable', 'available']
    }
    {
      method: 'DELETE'
      path: '/v1/dashboard/side_dishes/{key}'
      config:
        handler: SideDish.dashboard.remove
        validate: SideDishValidator::delete
        description: 'remove a side dish'
        auth: 'jwt'
        tags: ['meal','dashboard','side_dish', 'delete']
    }
    {
      method: 'POST'
      path: '/v1/dashboard/side_dishes/{key}/photo'
      config:
        handler: SideDish.dashboard.add_photo
        validate: SideDishValidator::add_photo
        payload:
          output: 'stream'
        description: 'add a photo to side dish'
        auth: 'jwt'
        tags: ['meal','dashboard','side_dish', 'photo']
    }
  ]
