module.exports = (server, options) ->
  
  Meals = require('./handlers/main') server, options

  return [
    {
      method: 'GET'
      path: '/v1/meals'
      config: {
        handler: Meals.list
        description: 'TODO: System generated this'
        tags: ['system', 'TODO']
      }
    }
  ]
