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
    main_dish: "#{faker.random.uuid()}"
    side_dishes: [faker.random.uuid(), faker.random.uuid(), faker.random.uuid()]
    at:  moment("2016-03-20").format('YYYY-MM-DD')  
    total: faker.random.number()

  get_dish = ->
    name:        faker.name.firstName()
    price:       faker.random.number()
    calories:    faker.random.number()
    contains:    faker.lorem.sentence()
    description: faker.lorem.sentence()
    isAvailable: "#{faker.random.boolean()}"


  describe 'daily meal', ->
    URL    = 'http://localhost:3100'
    meal = null
    dish = null

    beforeEach ->
      meal = get_daily_meal()
      dish = get_dish()

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

    it 'should get detail of a daily meal', ->
      chai.request(URL)
        .post('/v1/dashboard/main_dishes')
        .field('name', dish.name)
        .field('price', dish.price)
        .field('calories', dish.calories)
        .field('contains', dish.contains)
        .field('description', dish.description)
        .field('isAvailable', dish.isAvailable)
      .then (main_dish) ->
        main_dish.should.have.status 200
        side_dishes = []
        chai.request(URL)
          .post('/v1/dashboard/side_dishes')
          .field('name', dish.name)
          .field('description', dish.description)
          .field('isAvailable', dish.isAvailable)
        .then (side_dish) ->
          side_dishes.push side_dish.body.data.success
          chai.request(URL)
            .post('/v1/dashboard/side_dishes')
            .field('name', dish.name)
            .field('description', dish.description)
            .field('isAvailable', "#{dish.isAvailable}")
        .then (side_dish) ->
          side_dishes.push side_dish.body.data.success
          chai.request(URL)
            .post('/v1/dashboard/side_dishes')
            .field('name', dish.name)
            .field('description', dish.description)
            .field('isAvailable', dish.isAvailable)
          .then (side_dish) ->
            side_dishes.push side_dish.body.data.success
            chai.request(URL)
              .post('/v1/dashboard/daily_meal')
              .field('main_dish', main_dish.body.data.success.doc_key)
              .field('side_dishes', side_dishes[0].doc_key )
              .field('side_dishes', side_dishes[1].doc_key)
              .field('side_dishes', side_dishes[2].doc_key )
              .field('at', meal.at)
              .field('total', meal.total)
              .then (daily_meal) ->
                daily_meal.should.have.status 200
                chai.request(URL)
                 .get('/v1/dashboard/daily_meal/'+daily_meal.body.data.success.doc_key)
                .then (dailymeal) ->
                  delete main_dish.body.data.success.doc_type
                  dailymeal.body.main_dish.should.be.deep.eq main_dish.body.data.success
                  dailymeal.body.side_dishes[0].name.should.be.deep.eq side_dishes[0].name
                  dailymeal.body.side_dishes[1].name.should.be.deep.eq side_dishes[1].name
                  dailymeal.body.side_dishes[2].name.should.be.deep.eq side_dishes[2].name

   it 'should edit a daily meal'
   it 'should delete a daily meal'
   it 'should save with images'
