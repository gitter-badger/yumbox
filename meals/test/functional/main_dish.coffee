chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
faker    = require 'faker'

chai.use chaiHttp

context 'Main Dish functional', ->
  describe 'Main Dish', ->
    URL    = 'http://localhost:3100'
    MAIN_DISH = {}

    beforeEach ->
      MAIN_DISH=
        name:        faker.name.firstName()
        price:       faker.random.number()
        calories:    faker.random.number()
        contains:    faker.hacker.phrase()
        description: faker.hacker.phrase()
       # image_files: [ "#{__dirname}/images/maindish.jpg", "#{__dirname}/images/maindish2.jpg" ]
        isAvailable: faker.random.boolean()

    it 'should create a main dish', ->
      chai.request(URL)
        .post '/v1/dashboard/main_dish'
        .field('name', MAIN_DISH.name)
        .field('price', MAIN_DISH.price)
        .field('calories', MAIN_DISH.calories)
        .field('contains', MAIN_DISH.contains)
        .field('contains', MAIN_DISH.description)
          .then (main_dish) ->
            main_dish.should.have.status 200

