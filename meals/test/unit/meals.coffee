should = require('chai').should()
Meal = require '../../src/models/meal'

context 'Meal', ->
	describe 'Structure', ->
    it 'should exist', ->
      Meal.should.exist
    it 'should have properties correctly added', ->
      Meal.should.have.property 'name'
      Meal.should.have.property 'doc_key'
      Meal.should.have.property 'remained'
      Meal.should.have.property 'total'
      Meal.should.have.property 'price'
    it 'should have a list of side_dishes', ->
      Meal.side_dish.should.be.instanceof 'Array'
      Meal.should.have.property 'side_dishes'
