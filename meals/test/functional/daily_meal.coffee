chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
faker    = require 'faker'
moment   = require 'moment'
chai.use chaiHttp

URL    = 'http://localhost:3100'
main_dish = null
side_dish = null
side_dish = null

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
        main_dish = response.body.data.success

create_side_dish = ->
  dish = get_side_dish_data()
  chai.request(URL)
    .post('/v1/dashboard/side_dishes')
    .field('name', dish.name)
      .then (response) ->
        side_dish = response.body.data.success

describe 'daily meal', ->
  beforeEach (done) ->
    create_main_dish()
      .then (created_main_dish) ->
        create_side_dish()
          .then (created_side_dish) ->
            done()

  it "should create a daily meal", ->
    chai.request(URL)
      .post('/v1/dashboard/daily_meals')
      .field('main_dish_key', main_dish.doc_key)
      .field('side_dish_keys', side_dish.doc_key)
      .field('side_dish_keys', side_dish.doc_key)
      .field('at', moment().add(1, 'd').format('YYYY-MM-DD'))
      .field('total', faker.random.number())
        .then (response) ->
          response.should.have.status 200
          response.body.data.success.should.have.property 'doc_key'
