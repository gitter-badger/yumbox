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
        tags: ['meal','dashboard','main_dish']
    }
  ]
