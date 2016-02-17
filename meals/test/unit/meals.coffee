should = require('chai').should()
moment = require 'moment'
_ = require 'lodash'
fs = require 'fs-extra'
sinon = require 'sinon'
server = require '../../../api/src/mock'
Q = require 'q'
faker = require 'faker'

Meal = require('../../src/models/meal') server,

context 'Meal', ->
  describe 'Souce Adapter', ->
    describe 'PREFIX', ->
      it 'should have PREFIX set to \'m\'', ->
        Meal::PREFIX.should.exist
        Meal::PREFIX.should.be.eq 'm'
 
    describe 'IMAGE', ->
      it 'should be an Object', ->
        Meal::IMAGE.should.be.an 'Object'

      it 'should have SMALL, MEDIUM, LARGE set with an array', ->
        Meal::IMAGE.SIZE.SMALL.should.be.an 'Array'
        Meal::IMAGE.SIZE.MEDIUM.should.be.an 'Array'
        Meal::IMAGE.SIZE.LARGE.should.be.an 'Array'
  
  describe 'Structure', ->
    meal = null
    data = null
    beforeEach () ->
      data =
        name:faker.name.firstName()
        side_dishes: faker.company.suffixes()
        total: faker.random.number()
        remained: faker.random.number()
        price: faker.random.number()
        calories: faker.random.number()
        description:faker.hacker.phrase()

      meal = new Meal data

    describe 'Properties', ->
      it 'should have properties correctly added', ->
        meal.doc.should.contain.all.keys [
          'name','side_dishes','price'
          'doc_key', 'doc_type'
          ]

      it 'should not accept some props', ->
        meal.doc.should.not.contain.any.keys [
          'calories', 'description', 'total', 'remained'
          ]
      
      it 'should not accept unknown props' , ->
        invalid_meal = new Meal
          unknown_prop: faker.name.firstName()

        invalid_meal.doc.should.not.have.key 'unknown_prop'

      it 'should have correct values set', ->
        meal.doc.name.should.be.eq data.name
        # to be completed for other fields..

    describe 'Methods', ->
      it 'should create a meal', ->
        key = meal.key
        key.should.be.eq meal.doc.doc_key

        meal.create()
          .then (result) ->
            Meal.get(key)
          .then (result) ->
            result.doc.should.be.deep.eq meal.doc
            
      it 'should have correct values when inserted'

      it 'should have correct updated values when edited'
      
      it 'should not exist after deletation'
