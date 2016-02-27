chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
faker    = require 'faker'

chai.use chaiHttp

context 'Main Dishes functional', ->
  get_dish = ->
    name:        faker.name.firstName()
    price:       1234
    calories:    10000
    contains:    faker.lorem.sentence()
    description: faker.lorem.sentence()
    isAvailable: faker.random.boolean()

  describe 'Main Dishes', ->
    URL    = 'http://localhost:3100'
    dish = null

    beforeEach ->
      dish = get_dish()
      

    it 'should create a main dish', ->
      chai.request(URL)
        .post '/v1/dashboard/main_dishes'
        .field('name', dish.name)
        .field('price', dish.price)
        .field('calories', dish.calories)
        .field('contains', dish.contains)
        .field('description', dish.description)
          .then (main_dish) ->
            main_dish.should.have.status 200
            result = main_dish.body.data.success
            main_dish.body.data.success.name.should.be.eq dish.name
            main_dish.body.data.success.should.contains.key "doc_key"
            main_dish.body.data.success.should.contains.key "doc_type"

    it 'should edit a main dish', ->
      chai.request(URL)
