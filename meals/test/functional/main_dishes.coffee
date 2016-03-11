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
    price:       faker.random.number() 
    calories:    faker.random.number()
    contains:    faker.lorem.sentence()
    description: faker.lorem.sentence()
    isAvailable: "#{faker.random.boolean()}"

  describe 'Main Dishes', ->
    URL    = 'http://localhost:3100'
    dish = null

    beforeEach ->
      dish = get_dish()

    it 'should create a main dish', ->
      chai.request(URL)
        .post('/v1/dashboard/main_dishes')
        .field('name', dish.name)
        .field('price', dish.price)
        .field('contains', dish.contains)
        .field('description', dish.description)
        .field('calories', dish.calories)
        .field('isAvailable', dish.isAvailable)
          .then (main_dish) ->
            main_dish.should.have.status 200
            console.log dish.isAvailable , 1111111111111111
            console.log main_dish.body.data.success.isAvailable, ".>>>>..............."
            delete main_dish.body.data.success.doc_key
            delete main_dish.body.data.success.doc_type
            main_dish.body.data.success.should.be.deep.eq dish

    it 'should get details of a main dish', ->
      chai.request(URL)
        .post('/v1/dashboard/main_dishes')
        .field('name', dish.name)
        .field('price', dish.price)
        .field('calories', dish.calories)
        .field('contains', dish.contains)
        .field('description', dish.description)
        .field('isAvailable', dish.isAvailable)
      .then (created_main_dish) ->
        created_main_dish.should.have.status 200
        chai.request(URL)
          .get('/v1/dashboard/main_dishes/'+created_main_dish.body.data.success.doc_key)
          .then (stored_main_dish) ->
            stored_main_dish.should.have.status 200

    it 'should edit a main dish'
    it 'should delete a main dish'
    it 'should save with images'
