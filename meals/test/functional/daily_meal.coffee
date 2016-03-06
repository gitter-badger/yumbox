chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
faker    = require 'faker'
moment   = require 'moment'
chai.use chaiHttp

context 'Daily Meal functional', ->
  get_daily_meal = ->
    main_dish: faker.random.uuid()
    side_dishes: [faker.random.uuid(), faker.random.uuid(), faker.random.uuid()]
    at: moment(). format()
    total: "#{faker.random.number() }"

   # remained is off

  describe 'daily meal', ->
    URL    = 'http://localhost:3100'
    meal = null

    beforeEach ->
      meal = get_daily_meal()
      
    it 'should create a daily meal', ->
      chai.request(URL)
        .post '/v1/dashboard/daily_meal'
        .field('main_dish', meal.main_dish)
        .field('side_dishes', meal.side_dishes[0])
        .field('side_dishes', meal.side_dishes[1])
        .field('side_dishes', meal.side_dishes[2])
        .field('at', meal.at)
        .field('total', meal.total)
          .then (daily_meal) ->
            daily_meal.should.have.status 200
            delete daily_meal.body.data.success.doc_key
            delete daily_meal.body.data.success.doc_type
            daily_meal.body.data.success.should.be.deep.eq meal
    it 'should get a daily meal'
    it 'should edit a daily meal'
      
    it 'should delete a daily meal'
    it 'should save with images'
