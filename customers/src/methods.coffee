module.exports = (server, options) ->
  Customer = require("./models/customer") server, options
  #server.method 'method.name', () ->
  #  Do Something Cool which can be used by other plugins (such as exposing data)
  server.method 'customer.add_order', (order) ->
    Customer.get(order.customer_key)
      .then (customer) ->
        customer.add_order order
