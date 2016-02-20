should = require('chai').should()
moment = require 'moment'
_      = require 'lodash'
fs     = require 'fs-extra'
sinon  = require 'sinon'
server = require '../../../api/src/mock'
Q      = require 'q'
faker  = require 'faker'
Path = require 'path'

Order = require("../../src/models/order") server,

context 'order', ->
  describe 'Souce Adapter', ->
    describe 'PREFIX', ->
      it 'should have PREFIX set to \'o\'', ->
        Order::PREFIX.should.exist
        Order::PREFIX.should.be.eq 'o'
 
  describe 'Structure', ->
    order = null
    data = null
    beforeEach () ->
      data =
        customer_key:  faker.random.uuid()
        daily_meal_key:faker.random.number()
        quantity:      faker.random.number()
        at:            "#{faker.date.recent()}"
        status:        faker.hacker.phrase()
        price:         faker.commerce.price()

      order = new Order data

    describe 'Properties', ->
      it 'should have properties correctly added', ->
        order.doc.should.contain.all.keys [
          'customer_key', 'daily_meal_key', 'quantity', 'at'
          'status', 'price'
          ]

      it 'should not accept unknown props' , ->
        invalid_order = new Order
          unknown_prop: faker.name.firstName()

        invalid_order.doc.should.not.have.key 'unknown_prop'

      it 'should have correct values set', ->
        order.doc.customer_key.should.be.eq data.customer_key
        # to be completed for other fields..

    describe 'Behavior', ->
      it 'should create an order', ->
        key = order.key
        order.create(true)
          .then (result) ->
            Order.get(key)
          .then (result) ->
            result.doc.should.be.deep.eq order.doc
            key.should.be.eq order.doc.doc_key
            
      it 'should edit an order', ->
        key = order.key
        old_order = null
        order.create()
          .then ->
            Order.get(key)
          .then (result) ->
            old_order = result.doc
            updated_order = new Order result.doc.doc_key, {
              customer_key : 'c_231934221'
              daily_meal_key : 'd_8374656'
              quantity: '200'
              at: 'Feb 20 2016 06:22:38 GMT+0330 (IRST)'
              status: 'delivered'
              price: '22500'
            }
            updated_order.update()
          .then ->
            Order.get(key)
              .then (result) ->
                old_order.should.not.be.eq result.doc
                result.doc.customer_key.should.be.eq 'c_231934221'
                result.doc.daily_meal_key.should.be.eq 'd_8374656'
                result.doc.quantity.should.be.eq '200'
                result.doc.at.should.be.eq 'Feb 20 2016 06:22:38 GMT+0330 (IRST)'
                result.doc.status.should.be.eq 'delivered'
                result.doc.price.should.be.eq '22500'

      it 'should delete a order', ->
        order = null
        data =
          customer_key:  faker.random.uuid()
          daily_meal_key:faker.random.number()
          quantity:      faker.random.number()
          at:            faker.date.recent()
          status:        faker.hacker.phrase()
          price:         faker.commerce.price()
 
        order = new Order data

        key = order.key
        order.create()
          .then (result) ->
            order.remove(key)
          .then (is_deleted) ->
        Order.get(key)
          .then (result) ->
            result.should.be.an 'Error'
