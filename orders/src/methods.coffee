module.exports = (server, options) ->
  Order = require("./models/order") server, options
  server.method 'order.find' , (keys) ->
    Order.find keys
  #server.method 'method.name', () ->
  #  Do Something Cool which can be used by other plugins (such as exposing data)
