Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'
moment =  require 'moment'

module.exports = (server, options) ->
  return class DailyMeal extends server.methods.model.Base()
    
    PREFIX: 'd'

    props:
      main_dish_key: on
      side_dish_keys: on
      at: on
      total: on
      remained: on

    _mask: 'main_dish,side_dishes,at,total,doc_key'

    @get_upcomings: ->
      query =
        body:
          size: 3
          query:
            filtered:
              query:
                match_all: {}
              filter:
                range:
                  at:
                    gte:  moment().format('YYYY-MM-DD')
                    lte:   moment().add(3,'d').format('YYYY-MM-DD')
      @search('daily_meal', query)
        .then (daily_meals) =>
          return Q if daily_meals.hits.total < 1
          ids = []
          _.each daily_meals.hits.hits, (daily_meal)->
            ids.push daily_meal._id
            
          @find(ids, true)
