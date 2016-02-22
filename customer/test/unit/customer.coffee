should = require('chai').should()
moment = require 'moment'
_      = require 'lodash'
fs     = require 'fs-extra'
sinon  = require 'sinon'
server = require '../../../api/src/mock'
Q      = require 'q'
faker  = require 'faker'
Path = require 'path'

Customer = require("../../src/models/customer") server,

context 'Customer', ->
  describe 'Source Adapter', ->
    describe 'PREFIX', ->
      it 'should have PREFIX set to \'c\'', ->
        Customer::PREFIX.should.exist
        Customer::PREFIX.should.be.eq 'c'
 
  describe 'Structure', ->
    customer = null
    data = null
    beforeEach () ->
      data =
        name:             faker.name.firstName()
        location:
          latitude :      faker.address.latitude()
          longitude:      faker.address.longitude()
        phone:            faker.phone.phoneNumberFormat()
        mobile:           faker.phone.phoneNumberFormat()
        email:            faker.internet.email()
        avatar:  [ "#{__dirname}/images/example_image.jpg" ]
        dob:              "#{faker.date.past()}"
        orders:           faker.company.suffixes()
        image_files:      []

      customer = new Customer data

    describe 'Properties', ->
      it 'should have properties correctly added', ->
        customer.doc.should.contain.all.keys [
          'location', 'mobile', 'phone', 'name', 'avatar', 'orders', 'image_files'
          ]

      it 'should not accept some props', ->
        customer.doc.should.not.contain.any.keys [
          'email', 'dob'
          ]
      
      it 'should not accept unknown props' , ->
        invalid_customer = new Customer
          unknown_prop: faker.name.firstName()
        invalid_customer.doc.should.not.have.key 'unknown_prop'

      it 'should have correct values set', ->
        customer.doc.name.should.be.eq                  data.name
        customer.doc.location['latitude'].should.be.eq  data.location['latitude']
        customer.doc.location['longitude'].should.be.eq data.location['longitude']
        customer.doc.phone.should.be.eq                 data.phone
        customer.doc.mobile.should.be.eq                data.mobile
        #customer avatar                            
        customer.doc.orders.should.be.deep.eq           data.orders

    describe 'Behavior', ->
      it 'should create a customer', ->
        key = customer.key
        customer.create(true)
          .then (result) ->
            Customer.get(key)
          .then (result) ->
            result.doc.should.be.deep.eq customer.doc
            key.should.be.eq customer.doc.doc_key
            
      it 'should edit a customer', ->
        key = customer.key
        old_customer = null
        customer.create()
          .then ->
            Customer.get(key)
          .then (result) ->
            old_customer = result.doc
            updated_customer = new Customer result.doc.doc_key, {
              location:
                latitude: '17.9435'
                longitude:'-17.9435'
              phone:      '02128024679'
              mobile:     '09128024679'
              avatar: 'adadq22e89v sfsDFS(fSDFVSFSD)TWB$<T$TBOWTKSMV GS$# &N# $  v'
              orders:     ['o_123', 'o_321', 'o_111']
            }
            updated_customer.update()
          .then ->
            Customer.get(key)
              .then (result) ->
                old_customer.should.not.be.eq result.doc
                result.doc.location['latitude'].should.be.eq '17.9435'
                result.doc.location.longitude.should.be.eq '-17.9435'
                result.doc.phone.should.be.eq '02128024679'
                result.doc.mobile.should.be.eq '09128024679'
                result.doc.avatar.should.be.eq 'adadq22e89v sfsDFS(fSDFVSFSD)TWB$<T$TBOWTKSMV GS$# &N# $  v'
                result.doc.orders.should.be.deep.eq ['o_123', 'o_321', 'o_111']
 
      it 'should delete a customer', ->
        customer = null
        customer = new Customer data

        key = customer.key
        customer.create()
          .then (result) ->
            Customer.remove(key)
          .then (is_deleted) ->
        Customer.get(key)
          .then (result) ->
            result.should.be.an 'Error'

      it "should remove image_files on create", ->
        customer.create()
          .then (o) ->
            Customer.get(customer.key)
              .then (obj) ->
                obj.doc.should.have.property "avatar"
                obj.doc.should.not.have.property "image_files"
