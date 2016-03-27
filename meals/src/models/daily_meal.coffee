Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'
ShortID = require 'shortid'
moment =  require 'moment'

module.exports = (server, options) ->
  return class DailyMeal extends server.methods.model.Base()
    SideDish = require('./side_dish') server, options
    MainDish = require('./main_dish') server, options
    PREFIX: 'd'

    props:
      main_dish_key: on
      side_dish_keys: on
      at: on
      total: on
      remained: on

    _mask: 'main_dish,side_dishes,at,total,doc_key'
    

    register_order: (order) ->
      count = order.quantity
      @doc.remaineds = @doc.remaineds - count
      return Boom.resourceGone("This meal is not available anymore") unless @doc.remaineds > 0
      @doc.orders ?= []
      @doc.orders.push order.doc_key
      @update(true)
        .then (result) ->
          result
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

     @list_all: ->
      query =
        body:
          sort:
            at:
              order: "desc"
          query:
            match_all: {}

      @search('daily_meal', query)
        .then (results) =>
          daily_meals = []
          promises = []
          _.each results.hits.hits, (result) =>
            promises.push Q.fcall =>
              doc = result._source.doc
              main_dish_key = doc.main_dish_key
              side_dishes_key = doc.side_dish_keys
              SideDish.find(side_dishes_key)
                .then (side_dishes) ->
                  return Boom.badImplementation "something's wrong" if side_dishes instanceof Error
                  MainDish.find(main_dish_key)
                    .then (main_dish) ->
                       return Boom.badImplementation "something's wrong" if main_dish instanceof Error
                       doc.main_dish = main_dish
                       doc.side_dishes = side_dishes
                       delete doc.main_dish_key
                       delete doc.side_dish_keys
                       daily_meals.push doc

          Q.all(promises)
            .then (result) ->
              daily_meals
