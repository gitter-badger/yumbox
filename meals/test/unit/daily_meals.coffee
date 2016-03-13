should = require('chai').should()
moment = require 'moment'
_ = require 'lodash'
fs = require 'fs-extra'
sinon = require 'sinon'
server = require '../../../api/src/mock'
Q = require 'q'
faker = require 'faker'
Path = require 'path'

SideDish = require("../../src/models/side_dish") server,
MainDish = require("../../src/models/main_dish") server,
DailyMeal = require("../../src/models/daily_meal") server,

describe 'DailyMeal', ->
  daily_meal = null
  data = null

  get_main_dish_data = ->
    name: faker.name.firstName()
    is_available: faker.random.boolean()
    price: faker.random.number()
    calories: faker.random.number()
    contains: faker.company.suffixes()

  get_side_dish_data = ->
    name: faker.name.firstName()
    is_available: faker.random.boolean()

  get_daily_meal = ->
    main_dish = new MainDish get_main_dish_data()
    side_dish_1 = new SideDish get_side_dish_data()
    side_dish_2 = new SideDish get_side_dish_data()
    
    main_dish.create()
      .then ->
        side_dish_1.create()
      .then ->
        side_dish_2.create()
      .then ->
        data =
          main_dish_key: main_dish.key
          side_dish_keys:[side_dish_1.key, side_dish_2.key]
          at: moment(faker.date.future()).format()
          total: faker.random.number()
        data

  beforeEach (done) ->
    get_daily_meal()
      .then (data) ->
        daily_meal = new DailyMeal data
        done()

  it 'should have PREFIX set to \'d\'', ->
    DailyMeal::PREFIX.should.exist
    DailyMeal::PREFIX.should.be.eq 'd'
  
  it 'should have properties correctly added', ->
    daily_meal.doc.should.contain.all.keys [
      'main_dish_key', 'side_dish_keys', 'at'
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
    daily_meal.doc.main_dish_key.should.be.eq data.main_dish_key
    daily_meal.doc.side_dish_keys.should.be.deep.eq data.side_dish_keys
    daily_meal.doc.at.should.be.eq data.at
    daily_meal.doc.total.should.be.eq data.total
    #remained is off 

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
    daily_meal.create(true)
      .then (result) ->
        old_daily_meal = result
        get_daily_meal()
          .then (data) ->
            updated_daily_meal = new DailyMeal key, data
            updated_daily_meal.update()
              .then ->
                DailyMeal.get(key)
                  .then (result) ->
                    result.key.should.be.eq key
                    result.doc.main_dish_key.should.be.eq updated_daily_meal.doc.main_dish_key
                    result.doc.at.should.be.eq updated_daily_meal.doc.at

  it 'should delete a daily_meal', ->
    key = daily_meal.key
    daily_meal.create()
      .then (result) ->
        DailyMeal.remove(key)
      .then (is_deleted) ->
    DailyMeal.get(key)
      .then (result) ->
        result.should.be.an 'Error'
