chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
faker    = require 'faker'

chai.use chaiHttp

context 'Main Dishes functional', ->
  describe 'Main Dishes', ->
    URL    = 'http://localhost:3100'
    MAIN_DISHES = {}

    beforeEach ->
      MAIN_DISHES=
        name:        faker.name.firstName()
        price:       faker.random.number()
        calories:    faker.random.number()
        contains:    faker.hacker.phrase()
        description: faker.hacker.phrase()
       # image_files: [ "#{__dirname}/images/maindishes.jpg", "#{__dirname}/images/maindishes2.jpg" ]
        isAvailable: faker.random.boolean()

    it 'should create a main dishes', ->
      chai.request(URL)
        .post '/v1/dashboard/main_dishes'
        .field('name', MAIN_DISHES.name)
        .field('price', MAIN_DISHES.price)
        .field('calories', MAIN_DISHES.calories)
        .field('contains', MAIN_DISHES.contains)
        .field('contains', MAIN_DISHES.description)
          .then (main_dishes) ->
            main_dishes.should.have.status 200
