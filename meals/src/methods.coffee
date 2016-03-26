module.exports = (server, options) ->
  DailyMeal = require("./models/daily_meal") server, options

  server.method 'daily_meal.register_order', (order) ->
   DailyMeal.get(order.daily_meal_key).then (daily_meal) ->
     daily_meal.register_order order
