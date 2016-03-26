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
        auth: 'jwt'
        tags: ['meal','dashboard','daily_meal', 'create']
    }
    {
      method: 'GET'
      path: '/v1/dashboard/daily_meals'
      config:
        handler: (request, response) -> true #TODO "<<<<<<<<<<<<<<"
        description: 'list daily meal'
        auth: 'jwt'
        tags: ['meal','dashboard','daily_meal', 'list']
    }
    {
      method: 'PUT'
      path: '/v1/dashboard/daily_meals/{key}'
      config:
        handler: DailyMeal.dashboard.edit
        validate: DailyMealValidator::edit
        description: 'Updates maindish'
        auth: 'jwt'
        tags: ['meal','daily_meal', 'update','edit']
    }
    {
      method: 'DELETE'
      path: '/v1/dashboard/daily_meals/{key}'
      config:
        handler: DailyMeal.dashboard.remove
        validate: DailyMealValidator::delete
        description: 'remove a daily meal'
        auth: 'jwt'
        tags: ['meal','dashboard','daily_meal', 'delete']
    }
    {
      method: 'GET'
      path: '/v1/dashboard/daily_meals/{key}'
      config:
        handler: DailyMeal.dashboard.detail
        validate: DailyMealValidator::detail
        description: 'get detail of daily meal'
        auth: 'jwt'
        tags: ['meal','dashboard','daily_meal', 'get']
    }
    {
      method: 'GET'
      path: '/v1/app/daily_meal/{key}'
      config:
        handler: DailyMeal.app.detail
        validate: DailyMealValidator::detail
        description: 'get details of meal'
        tags: ['app','daily_meal','meal', 'detail']
    }
    {
      method: 'GET'
      path: '/v1/app/feed'
      config:
        handler: DailyMeal.app.feed
        validate: DailyMealValidator::get
        description: 'get upcoming meals'
        tags: ['app','daily_meal','meal', 'feed']
    }
  ]
