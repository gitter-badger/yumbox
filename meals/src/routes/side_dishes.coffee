SideDishValidator = require '../models/mainDishValidator'

module.exports = (server, options) ->
  SideDish = require('../handlers/side_dishes') server, options
 
  return [
    {
      method: 'POST'
      path: '/v1/dashboard/side_dishes'
      config:
        handler: SideDish.dashboard.create
        validate: SideDishValidator::create
        payload:
          output: 'stream'
    }
  ]
###
    {
      # GET method for reading side_dishes
      method: 'GET'
      path:   'v1/dashboard/side_dish'
      config:
    }
      # POST method for creating side_dish
      method: 'POST'
      path: 'v1/dashboard/side_dishes'
      config:
    }
    {
      # GET method for reading side_dishes
      method: 'GET'
      path:   'v1/dashboard/side_dish'
      config:
    }
    {
      #  
    }

###
