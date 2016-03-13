chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
faker    = require 'faker'

chai.use chaiHttp

get_dish = ->
  name:        faker.name.firstName()
  price:       faker.random.number()
  calories:    faker.random.number()
  contains:    faker.lorem.sentence()
  description: faker.lorem.sentence()
  is_available: "#{faker.random.boolean()}"

describe 'Main Dishes', ->
  URL    = 'http://localhost:3100'
  dish = null

  beforeEach ->
    dish = get_dish()
  
  it 'should be able to create a main dish', ->
    chai.request(URL)
      .post('/v1/dashboard/main_dishes')
      .field('name', dish.name)
      .field('price', dish.price)
      .field('contains', dish.contains)
      .field('description', dish.description)
      .field('calories', dish.calories)
        .then (response) ->
          response.should.have.status 200
          response.body.data.success.should.have.property 'doc_key'
          response.body.data.success.should.have.property 'is_available'
          response.body.data.success.is_available.should.be.false

  it 'should be able to list available main dishes', ->
    chai.request(URL)
      .get('/v1/dashboard/main_dishes')
      .then (response) ->
        response.body.data.should.be.instanceof Array

  it 'should get a main dish by key', ->
    chai.request(URL)
      .post('/v1/dashboard/main_dishes')
      .field('name', dish.name)
      .field('price', dish.price)
      .field('contains', dish.contains)
      .field('description', dish.description)
      .field('calories', dish.calories)
        .then (response) ->
          key = response.body.data.success.doc_key
          chai.request(URL)
            .get("/v1/dashboard/main_dishes/#{key}")
            .then (response) ->
              response.body.data.success.doc_key.should.be.eq key

  it 'should be able to toggle main dish availability', ->
    chai.request(URL)
      .post('/v1/dashboard/main_dishes')
      .field('name', dish.name)
      .field('price', dish.price)
      .field('contains', dish.contains)
      .field('description', dish.description)
      .field('calories', dish.calories)
        .then (response) ->
          key = response.body.data.success.doc_key
          chai.request(URL)
            .get("/v1/dashboard/main_dishes/#{key}")
            .then (response) ->
              key = response.body.data.success.doc_key
              chai.request(URL)
                .put("/v1/dashboard/main_dishes/#{key}/toggle")
              .then (response) ->
                chai.request(URL)
                  .get("/v1/dashboard/main_dishes/#{key}")
              .then (response) ->
                response.body.data.success.is_available.should.be.true

  it 'should be able to list available main dishes', ->
    chai.request(URL)
      .get('/v1/dashboard/main_dishes')
      .then (response) ->
        response.body.data.should.be.instanceof Array

  it 'should edit a main dish'
  it 'should delete a main dish'
  it 'should save with images'

