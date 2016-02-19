should = require('chai').should()
moment = require 'moment'
_      = require 'lodash'
fs     = require 'fs-extra'
sinon  = require 'sinon'
server = require '../../../api/src/mock'
Q      = require 'q'
faker  = require 'faker'

SideDish = require('../../src/models/side_dish') server,

context 'SideDish', ->
  describe 'Souce Adapter', ->
    describe 'PREFIX', ->
      it 'should have PREFIX set to \'s\'', ->
        SideDish::PREFIX.should.exist
        SideDish::PREFIX.should.be.eq 's'
 
    describe 'IMAGE', ->
      it 'should be an Object', ->
        SideDish::IMAGE.should.be.an 'Object'

      it 'should have SMALL, MEDIUM, LARGE set with an array', ->
        SideDish::IMAGE.SIZE.SMALL.should.be.an 'Array'
        SideDish::IMAGE.SIZE.MEDIUM.should.be.an 'Array'
        SideDish::IMAGE.SIZE.LARGE.should.be.an 'Array'
  
  describe 'Structure', ->
    side_dish = null
    data = null
    beforeEach () ->
      data =
        name:        faker.name.firstName()
        total:       faker.random.number()
        remained:    faker.random.number()
        price:       faker.random.number()
        calories:    faker.random.number()
        description: faker.hacker.phrase()

      side_dish = new SideDish data

    describe 'Properties', ->
      it 'should have properties correctly added', ->
        side_dish.doc.should.contain.all.keys [
          'name', 'doc_key', 'doc_type'
          ]

      it 'should not accept some props', ->
        side_dish.doc.should.not.contain.any.keys [
          'price', 'description', 'total', 'remained'
          ]
      
      it 'should not accept unknown props' , ->
        invalid_side_dish = new SideDish
          unknown_prop: faker.name.firstName()

        invalid_side_dish.doc.should.not.have.key 'unknown_prop'

      it 'should have correct values set', ->
        side_dish.doc.name.should.be.eq data.name
        # to be completed for other fields..

    describe 'Behavior', ->
      it 'should create a side_dish', ->
        key = side_dish.key
        side_dish.create()
          .then (result) ->
            SideDish.get(key)
          .then (result) ->
            result.doc.should.be.deep.eq side_dish.doc
            key.should.be.eq side_dish.doc.doc_key
            
      it 'should edit a side_dish', ->
        key = side_dish.key
        old_side_dish = null
        side_dish.create()
          .then ->
            SideDish.get(key)
          .then (result) ->
            old_side_dish = result.doc
            updated_side_dish = new SideDish result.doc.doc_key, {
              name : 'new_name'
              price : 15000
            }
            updated_side_dish.update()
          .then ->
            SideDish.get(key)
              .then (result) ->
                old_side_dish.should.not.be.eq result.doc
                result.doc.name.should.be.eq 'new_name'
      
      it 'should delete a side_dish', ->
        side_dish = null
        data =
          name:faker.name.firstName()
          total: faker.random.number()
          remained: faker.random.number()
          price: faker.random.number()
          calories: faker.random.number()
          description:faker.hacker.phrase()

        side_dish = new SideDish data


        key = side_dish.key
        side_dish.create()
          .then (result) ->
            SideDish.remove(key)
          .then (is_deleted) ->
        SideDish.get(key)
          .then (result) ->
            result.should.be.an 'Error'
