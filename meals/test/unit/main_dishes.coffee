should = require('chai').should()
moment = require 'moment'
_ = require 'lodash'
fs = require 'fs-extra'
sinon = require 'sinon'
server = require '../../../api/src/mock'
Q = require 'q'
faker = require 'faker'
Path = require 'path'

MainDish = require("../../src/models/main_dish") server,

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
        name: faker.name.firstName()
        price: faker.random.number()
        calories: faker.random.number()
        contains: faker.company.suffixes()
        description: faker.hacker.phrase()
        images: [ "#{__dirname}/images/example_image.jpg" ]
        image_files: []
        isAvailable: faker.random.boolean()

      main_dish = new MainDish data

    describe 'Properties', ->
      it 'should have properties correctly added', ->
        main_dish.doc.should.contain.all.keys [
          'name','price', 'doc_key', 'doc_type',
          'calories', 'description', 'contains', 
          ]

      it 'should not accept some props', ->
        main_dish.doc.should.not.contain.any.keys [
         'images', 'image_files'
          'isAvailable'
          ]
      
      it 'should not accept unknown props' , ->
        invalid_main_dish = new MainDish
          unknown_prop: faker.name.firstName()
        invalid_main_dish.doc.should.not.have.key 'unknown_prop'

      it 'should have correct values set', ->
        main_dish.doc.name.should.be.eq data.name
        main_dish.doc.price.should.be.eq data.price

      describe 'Images', ->
        it 'should be saved with images', ->
          main_dish.create(true)
            .then (res) ->
              res.doc_key.should.be.equal main_dish.key
              res.should.have.not.property 'images'

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
              name:  'pizza'
              price: '24800'
              images: [ "#{__dirname}/images/example_image_2.jpg" ]
              isAvailable: no
            }
            updated_main_dish.update()
          .then ->
            MainDish.get(key)
              .then (result) ->
                old_main_dish.should.not.be.eq result.doc
                result.doc.name.should.be.eq  'pizza'
                result.doc.price.should.be.eq '24800'
                #images is off
                #isAvailable is off

      it 'should delete a main_dish', ->
        key = main_dish.key
        main_dish.create()
          .then (result) ->
            MainDish.remove(key)
          .then (is_deleted) ->
        MainDish.get(key)
          .then (result) ->
            result.should.be.an 'Error'
