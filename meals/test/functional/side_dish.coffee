chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
faker    = require 'faker'

chai.use chaiHttp

get_dish = ->
  name:        faker.name.firstName()

describe 'Side dish', ->
  URL    = 'http://localhost:3100'
  dish = null

  beforeEach ->
    dish = get_dish()

  it 'should be able to create a side dish', ->
    chai.request(URL)
      .post('/v1/dashboard/side_dishes')
      .field('name', dish.name)
        .then (response) ->
          response.should.have.status 200
          response.body.data.success.should.have.property 'doc_key'
          response.body.data.success.should.have.property 'is_available'
          response.body.data.success.is_available.should.be.false

  it 'should be able to list available side dishes', ->
    chai.request(URL)
      .get('/v1/dashboard/side_dishes')
      .then (response) ->
        response.body.data.should.be.instanceof Array

  it 'should be able to toggle side dish availability', ->
    chai.request(URL)
      .post('/v1/dashboard/side_dishes')
      .field('name', dish.name)
        .then (response) ->
          key = response.body.data.success.doc_key
          chai.request(URL)
            .put("/v1/dashboard/side_dishes/#{key}/toggle")
              .then (response) ->
                chai.request(URL)
                  .get("/v1/dashboard/side_dishes/#{key}")
        .then (response) ->
          response.body.data.is_available.should.be.true
