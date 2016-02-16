should = require('chai').should()
Meal = require '../../src/models/meal'

context 'Meal', ->
	describe 'Structure', ->
    it 'should exist', ->
      Meal.should.exist
    it 'should have properties correctly added', ->
      Meal.should.have.property 'name'
      Meal.should.have.property 'key'
      Meal.should.have.property 'side_dish'
      Meal.should.have.property 'remained'
      Meal.should.have.property 'total'
      Meal.should.have.property 'price'
    it '\'s side_dish property should be an array', ->
      Meal.side_dish.should.be.an 'array'
