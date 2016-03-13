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

describe 'MainDish', ->
  main_dish = null
  data = null

  beforeEach () ->
    data =
      name: faker.name.firstName()
      is_available: faker.random.boolean()
      price: faker.random.number()
      calories: faker.random.number()
      contains: faker.company.suffixes()
      description: faker.hacker.phrase()
    
    main_dish = new MainDish data

  it 'should have PREFIX set to \'m\'', ->
    MainDish::PREFIX.should.exist
    MainDish::PREFIX.should.be.eq 'm'
   
  it 'should have properties correctly added', ->
    main_dish.doc.should.contain.all.keys [
      'name', 'is_available', 'doc_key', 'doc_type'
      'price', 'calories', 'contains', 'description'
      ]

  it 'should not accept some props', ->
    main_dish.doc.should.not.contain.any.keys [
      'images'
      ]
  
  it 'should not accept unknown props' , ->
    invalid_main_dish = new MainDish
      unknown_prop: faker.name.firstName()
    invalid_main_dish.doc.should.not.have.key 'unknown_prop'

  it 'should have correct values set', ->
    main_dish.doc.name.should.be.eq data.name

  it 'should create a main_dish', ->
    key = main_dish.key
    main_dish.create(true)
      .then (result) ->
        MainDish.get(key)
      .then (result) ->
        result.doc.should.be.deep.eq main_dish.doc
        key.should.be.eq main_dish.doc.doc_key
        
  it 'should add photo', ->
    photo = "#{__dirname}/images/example_image.jpg"
    key = main_dish.key
    main_dish.create(true)
      .then (result) ->
        main_dish.photo = photo
        main_dish.update(true)
      .then (result) ->
        fs.existsSync(main_dish.get_full_path "small.jpg").should.be.true
        fs.existsSync(main_dish.get_full_path "medium.jpg").should.be.true
        fs.existsSync(main_dish.get_full_path "large.jpg").should.not.be.true

  it 'should edit a main_dishes', ->
    key = main_dish.key
    old_main_dish = null
    main_dish.create()
      .then ->
        MainDish.get(key)
      .then (result) ->
        old_main_dish = result.doc
        updated_main_dish = new MainDish result.doc.doc_key, {
          name : 'maindish'
          is_available: yes
        }
        updated_main_dish.update()
      .then ->
        MainDish.get(key)
          .then (result) ->
            old_main_dish.should.not.be.eq result.doc
            result.doc.name.should.be.eq 'maindish'

  it 'should delete a main_dish', ->
    main_dish = new MainDish data
    key = main_dish.key
    main_dish.create()
      .then (result) ->
        MainDish.remove(key)
      .then (is_deleted) ->
    MainDish.get(key)
      .then (result) ->
        result.should.be.an 'Error'

  it 'should list all available main dishes', (done) ->
    MainDish.list_all()
      .then (results) ->
        done()
