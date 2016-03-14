DailyMealValidator = require '../models/dailyMealValidator'

module.exports = (server, options) ->

  DailyMeal = require('../handlers/daily_meal') server, options

  return [
    {
      method: 'POST'
      path: '/v1/dashboard/daily_meals'
      config:
        handler: DailyMeal.dashboard.create
        validate: DailyMealValidator::create
        payload:
          output: 'stream'
        description: 'Create a daily meal.'
        tags: ['meal','dashboard','daily_meal', 'create']
   }
   {
      method: 'PUT'
      path: '/v1/dashboard/daily_meals/{key}'
      config:
        handler: DailyMeal.dashboard.edit
        validate: DailyMealValidator::edit
        description: 'Updates maindish'
        tags: ['meal','daily_meal', 'update','edit']
   }
   {
      method: 'DELETE'
      path: '/v1/dashboard/daily_meals/{key}'
      config:
        handler: DailyMeal.dashboard.remove
        description: 'remove a daily meal'
        tags: ['meal','dashboard','daily_meal', 'delete']
   }
   {
      method: 'GET'
      path: '/v1/dashboard/daily_meals/{key}'
      config:
        handler: DailyMeal.dashboard.detail
        description: 'get detail of daily meal'
        tags: ['meal','dashboard','daily_meal', 'get']
   }
   {
      method: 'GET'
      path: '/v1/app/daily_meal/{key}'
      config:
        handler: DailyMeal.app.detail
        description: 'get details of meal'
        tags: ['meal', 'feed']
   }
   {
      method: 'GET'
      path: '/v1/app/feed'
      config:
        handler: DailyMeal.app.feed
        description: 'get upcoming meals'
        tags: ['meal', 'feed']
   }
  ]
