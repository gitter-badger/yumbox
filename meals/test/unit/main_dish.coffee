should = require('chai').should()
moment = require 'moment'
_ = require 'lodash'
fs = require 'fs-extra'
sinon = require 'sinon'
server = require '../../../api/src/mock'
Q = require 'q'
faker = require 'faker'

MainDish = require('../../src/models/main_dish') server,

context 'MainDish', ->
  describe 'Souce Adapter', ->
    describe 'PREFIX', ->
      it 'should have PREFIX set to \'m\'', ->
        MainDish::PREFIX.should.exist
        MainDish::PREFIX.should.be.eq 'm'
 
    describe 'IMAGE', ->
      it 'should be an Object', ->
        MainDish::IMAGE.should.be.an 'Object'

      it 'should have SMALL, MEDIUM, LARGE set with an array', ->
        MainDish::IMAGE.SIZE.SMALL.should.be.an 'Array'
        MainDish::IMAGE.SIZE.MEDIUM.should.be.an 'Array'
        MainDish::IMAGE.SIZE.LARGE.should.be.an 'Array'
  
  describe 'Structure', ->
    main_dish = null
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

      main_dish = new MainDish data

    describe 'Properties', ->
      it 'should have properties correctly added', ->
        main_dish.doc.should.contain.all.keys [
          'name','price'
          'doc_key', 'doc_type'
          ]

      it 'should not accept some props', ->
        main_dish.doc.should.not.contain.any.keys [
          'calories', 'description', 'total', 'remained'
          ]
      
      it 'should not accept unknown props' , ->
        invalid_main_dish = new MainDish
          unknown_prop: faker.name.firstName()

        invalid_main_dish.doc.should.not.have.key 'unknown_prop'

      it 'should have correct values set', ->
        main_dish.doc.name.should.be.eq data.name
        # to be completed for other fields..

    describe 'Behavior', ->
      it 'should create a main_dish', ->
        key = main_dish.key
        main_dish.create()
          .then (result) ->
            MainDish.get(key)
          .then (result) ->
            result.doc.should.be.deep.eq main_dish.doc
            key.should.be.eq main_dish.doc.doc_key
            
      it 'should edit a main_dish', ->
        key = main_dish.key
        old_main_dish = null
        main_dish.create()
          .then ->
            MainDish.get(key)
          .then (result) ->
            old_main_dish = result.doc
            updated_main_dish = new MainDish result.doc.doc_key, {
              name : 'new_name'
              price : 15000
            }
            updated_main_dish.update()
          .then ->
            MainDish.get(key)
              .then (result) ->
                old_main_dish.should.not.be.eq result.doc
                result.doc.name.should.be.eq 'new_name'
                result.doc.price.should.be.eq 15000
      
      it 'should delete a main_dish', ->
        main_dish = null
        data =
          name:faker.name.firstName()
          total: faker.random.number()
          remained: faker.random.number()
          price: faker.random.number()
          calories: faker.random.number()
          description:faker.hacker.phrase()

        main_dish = new MainDish data


        key = main_dish.key
        main_dish.create()
          .then (result) ->
            MainDish.remove(key)
          .then (is_deleted) ->
        MainDish.get(key)
          .then (result) ->
            result.should.be.an 'Error'