should      = require('chai').should()
_           = require 'lodash'
server      = require '../../../api/src/mock'
faker       = require 'faker'
Q           = require  'q'
UserNotification  = require('../../src/models/user_notification') server,
  defaults:
    notification_size: 2

server.method 'notification.post', -> Q true
describe "notification", ->
  it "shoud be addable to a user notifications", ->
    
    create_notification = ->
      doc:
        data:
          type: 'type'
        user_key: "u_#{faker.random.uuid()}"
        title: faker.lorem.sentence()
        message: faker.lorem.sentences()

    notifications = []
    notifications.push create_notification() for [1..4]
        

    notification = new UserNotification "u_12313:notification", {}
    notification.create()
      .then ->
        notification.add notifications[0]
      .then ->
        notification.add notifications[1]
      .then ->
        notification.add notifications[2]
      .then ->
        notification.add notifications[3]
      .then (result) ->
         UserNotification.find("u_12313:notification", true)
      .then (result) ->
        result.list.should.have.length.of 2
        result.list[0].should.be.deep.equal notifications[3].doc
        result.list[1].should.be.deep.equal notifications[2].doc
        
