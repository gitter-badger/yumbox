should = require('chai').should()
moment = require 'moment'
_ = require 'lodash'
fs = require 'fs-extra'
sinon = require 'sinon'
server = require '../../../api/src/mock'
Q = require 'q'
faker = require 'faker'
Path = require 'path'

DailyMeal = require("../../src/models/daily_meal") server,

context 'DailyMeal', ->
  describe 'Souce Adapter', ->
    describe 'PREFIX', ->
      it 'should have PREFIX set to \'d\'', ->
        DailyMeal::PREFIX.should.exist
        DailyMeal::PREFIX.should.be.eq 'd'
  
  describe 'Structure', ->
    daily_meal = null
    data = null
    beforeEach () ->
      data =
        main_dish: faker.name.firstName()
        side_dishes: faker.company.suffixes()
        at: "#{faker.date.future()}"
        total: faker.random.number()
        remained: faker.random.number()

      daily_meal = new DailyMeal data

    describe 'Properties', ->
      it 'should have properties correctly added', ->
        daily_meal.doc.should.contain.all.keys [
          'main_dish', 'side_dishes', 'at'
          'total', 'doc_key', 'doc_type'
          ]

      it 'should not accept some props', ->
        daily_meal.doc.should.not.contain.any.keys [
          'remained'
          ]
      
      it 'should not accept unknown props' , ->
        invalid_daily_meal = new DailyMeal
          unknown_prop: faker.name.firstName()

        invalid_daily_meal.doc.should.not.have.key 'unknown_prop'

      it 'should have correct values set', ->
        daily_meal.doc.main_dish.should.be.eq        data.main_dish
        daily_meal.doc.side_dishes.should.be.deep.eq data.side_dishes
        daily_meal.doc.at.should.be.eq               data.at
        daily_meal.doc.total.should.be               data.total
        daily_meal.doc.remained.should.be.eq         data.remained

    describe 'Behavior', ->
      it 'should create a daily_meal', ->
        key = daily_meal.key
        daily_meal.create(true)
          .then (result) ->
            DailyMeal.get(key)
          .then (result) ->
            result.doc.at.should.be.deep.eq daily_meal.doc.at
            key.should.be.eq daily_meal.doc.doc_key
            
      it 'should edit a daily_meal', ->
        key = daily_meal.key
        old_daily_meal = null
        daily_meal.create()
          .then ->
            DailyMeal.get(key)
          .then (result) ->
            old_daily_meal = result.doc
            updated_daily_meal = new DailyMeal result.doc.doc_key, {
              main_dish : 'new_name'
              side_dishes : ['item1', 'item2', 'item3']
              at : 'Sat Feb 20 2016 21:58:24 GMT+0330 (IRST)'
              total: 400
            }
            updated_daily_meal.update()
          .then ->
            DailyMeal.get(key)
              .then (result) ->
                old_daily_meal.should.not.be.eq result.doc
                result.doc.main_dish.should.be.eq 'new_name'
                result.doc.side_dishes.should.be.deep.eq [ 'item1', 'item2', 'item3' ]
                result.doc.at.should.be.eq  'Sat Feb 20 2016 21:58:24 GMT+0330 (IRST)'
                result.doc.total.should.be.eq 400
      
      it 'should delete a daily_meal', ->
        key = daily_meal.key
        daily_meal.create()
          .then (result) ->
            DailyMeal.remove(key)
          .then (is_deleted) ->
        DailyMeal.get(key)
          .then (result) ->
            result.should.be.an 'Error'
