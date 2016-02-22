SideDishValidator = require '../models/mainDishValidator'

module.exports = (server, options) ->

  SideDish = require('../handlers/side_dish') server, options
 
  return [
 
    #POST method for creating           
    {
      method: 'POST'
      path: 'v1/dashboard/side_dishes'
      config:
        handler: SideDish.dashboard.create
        validate: SideDishValidator::create
        
    }
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


