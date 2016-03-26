chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
faker    = require 'faker'
moment   = require 'moment'
chai.use chaiHttp

URL    = 'http://localhost:3100'

get_main_dish_data = ->
  name: faker.name.firstName()
  price: faker.random.number()
  calories: faker.random.number()
  contains: faker.lorem.sentence()
  description: faker.hacker.phrase()

get_side_dish_data = ->
  name:         faker.name.firstName()
  is_available: faker.random.boolean()

create_main_dish = ->
  dish = get_main_dish_data()
  chai.request(URL)
    .post('/v1/dashboard/main_dishes')
    .field('name', dish.name)
    .field('price', dish.price)
    .field('contains', dish.contains)
    .field('description', dish.description)
    .field('calories', dish.calories)
      .then (response) ->
        response.body.data.success

create_side_dish = ->
  dish = get_side_dish_data()
  chai.request(URL)
    .post('/v1/dashboard/side_dishes')
    .field('name', dish.name)
      .then (response) ->
        response.body.data.success

describe 'daily meal', ->
  main_dish = null
  side_dish = null
  side_dish2 = null

  beforeEach (done) ->
    create_main_dish()
      .then (created_main_dish) ->
        main_dish = created_main_dish
        create_side_dish()
          .then (created_side_dish) ->
            side_dish = created_side_dish
            create_side_dish()
              .then (created_side_dish2) ->
                side_dish2 = created_side_dish2
                done()

  it "should create a daily meal", ->
    chai.request(URL)
      .post('/v1/dashboard/daily_meals')
      .field('main_dish_key', main_dish.doc_key)
      .field('side_dish_keys', side_dish.doc_key)
      .field('side_dish_keys', side_dish2.doc_key)
      .field('at', moment().add(1, 'd').format('YYYY-MM-DD'))
      .field('total', faker.random.number())
        .then (response) ->
          response.should.have.status 200
          response.body.data.success.should.have.property 'doc_key'

            
  it "should edit a daily meal", ->
    chai.request(URL)
      .post('/v1/dashboard/daily_meals')
      .field('main_dish_key', main_dish.doc_key)
      .field('side_dish_keys', side_dish.doc_key)
      .field('side_dish_keys', side_dish2.doc_key)
      .field('at', moment().add(1, 'd').format('YYYY-MM-DD'))
      .field('total', faker.random.number())
        .then (response) ->
          response.should.have.status 200
          chai.request(URL)
            .put("/v1/dashboard/daily_meals/#{response.body.data.success.doc_key}")
            .field('total', faker.random.number())
            .then (edited_daily_meal) ->
              edited_daily_meal.body.data.total.should.not.be.deep.eq response.body.data.success.total
              edited_daily_meal.body.data.at.should.be.deep.eq response.body.data.success.at
              edited_daily_meal.body.data.main_dish_key.should.be.deep.eq response.body.data.success.main_dish_key
            
