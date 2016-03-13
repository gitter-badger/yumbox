should = require('chai').should()
moment = require 'moment'
_      = require 'lodash'
fs     = require 'fs-extra'
sinon  = require 'sinon'
server = require '../../../api/src/mock'
Q      = require 'q'
faker  = require 'faker'
Path = require 'path'

SideDish = require("../../src/models/side_dish") server,{}

describe 'SideDishes', ->
  side_dish = null
  data = null

  beforeEach () ->
    data =
      name:         faker.name.firstName()
      is_available: faker.random.boolean()
    
    side_dish = new SideDish data

  it 'should have PREFIX set to \'s\'', ->
    SideDish::PREFIX.should.exist
    SideDish::PREFIX.should.be.eq 's'
   
  it 'should have properties correctly added', ->
    side_dish.doc.should.contain.all.keys [
      'name', 'is_available', 'doc_key', 'doc_type'
      ]

  it 'should not accept some props', ->
    side_dish.doc.should.not.contain.any.keys [
      'images'
      ]
  
  it 'should not accept unknown props' , ->
    invalid_side_dish = new SideDish
      unknown_prop: faker.name.firstName()
    invalid_side_dish.doc.should.not.have.key 'unknown_prop'

  it 'should have correct values set', ->
    side_dish.doc.name.should.be.eq data.name

  it 'should create a side_dish', ->
    key = side_dish.key
    side_dish.create(true)
      .then (result) ->
        SideDish.get(key)
      .then (result) ->
        result.doc.should.be.deep.eq side_dish.doc
        key.should.be.eq side_dish.doc.doc_key
        
  it 'should add photo', ->
    photo = "#{__dirname}/images/example_image.jpg"
    key = side_dish.key
    side_dish.create(true)
      .then (result) ->
        side_dish.photo = photo
        side_dish.update(true)
      .then (result) ->
        fs.existsSync(side_dish.get_full_path "small.jpg").should.be.true
        fs.existsSync(side_dish.get_full_path "medium.jpg").should.be.true
        fs.existsSync(side_dish.get_full_path "large.jpg").should.not.be.true

  it 'should edit a side_dishes', ->
    key = side_dish.key
    old_side_dish = null
    side_dish.create()
      .then ->
        SideDish.get(key)
      .then (result) ->
        old_side_dish = result.doc
        updated_side_dish = new SideDish result.doc.doc_key, {
          name : 'sidedish'
          is_available: yes
        }
        updated_side_dish.update()
      .then ->
        SideDish.get(key)
          .then (result) ->
            old_side_dish.should.not.be.eq result.doc
            result.doc.name.should.be.eq 'sidedish'

  it 'should delete a side_dish', ->
    side_dish = new SideDish data
    key = side_dish.key
    side_dish.create()
      .then (result) ->
        SideDish.remove(key)
      .then (is_deleted) ->
    SideDish.get(key)
      .then (result) ->
        result.should.be.an 'Error'

  it 'should list all available side dishes', (done) ->
    SideDish.list_all()
      .then (results) ->
        console.log results
        done()
    
