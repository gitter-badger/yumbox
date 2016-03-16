module.exports = (server, options) ->
  
  Customers = require('./handlers/main') server, options

  return [
    {
      method: 'GET'
      path: '/v1/customers'
      config: {
        handler: Customers.list
        description: 'TODO: System generated this'
        tags: ['system', 'TODO']
      }
    }
  ]
