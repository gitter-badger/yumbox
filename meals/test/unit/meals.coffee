should = require('chai').should()
Meal = require '../../src/models/meal'

context 'Meal', ->
	describe 'Structure', ->
    it 'should exist', ->
      Meal.should.exist
    
    it 'should have properties correctly added', ->
      meal = new Meal()
      meal.should.have.all.keys ['name', 'doc_key', 'remained', 'price']
      

    it 'should have a list of side_dishes', ->
      meal = new Meal()
      Meal.side_dish.should.be.instanceof 'Array'
      Meal.should.have.property 'side_dishes'
