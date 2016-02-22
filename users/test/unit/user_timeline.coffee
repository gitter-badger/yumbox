should      = require('chai').should()
_           = require 'lodash'
server      = require '../../../api/src/mock'
UserTimeline = require('../../src/models/user_timeline') server, { }
moment      = require 'moment'

describe 'UserTimeline', ->
  USER_KEY = "user1"
  TIMELINE =
    list: [
      {
        type: "activity",
        id: "a_1",
        name: "activity one"
      }
    ]
  describe 'class structure', ->
    it "should only accept limited props", ->
      timeline = new UserTimeline USER_KEY, TIMELINE
      timeline_data = _.merge {}, TIMELINE, {doc_key: timeline.key, doc_type: timeline.doc_type}
      timeline.doc.should.be.deep.equal timeline_data

    it "should assign correct key", ->
      timeline_key = "#{USER_KEY}#{UserTimeline::POSTFIX}"
      timeline = new UserTimeline USER_KEY, {}
      timeline.key.should.be.equal timeline_key

      timeline = new UserTimeline timeline_key, {}
      timeline.key.should.be.equal timeline_key

  describe "creation", ->
    it "should create an empty list before create", ->
      timeline = new UserTimeline USER_KEY, TIMELINE
      timeline.before_create().should.be.true
      timeline.doc.should.have.property 'list'

    it "should create timeline on get, if it is not existed", ->
      user1_timeline_key = "#{USER_KEY}#{UserTimeline::POSTFIX}"
      user2_key = "user2"

      UserTimeline.get_or_create(USER_KEY)
        .then (timeline) ->
          timeline.key.should.be.equal user1_timeline_key
          timeline.doc.should.have.property "list"
        UserTimeline.get(user1_timeline_key)
          .then (timeline) ->
            timeline.key.should.be.equal user1_timeline_key
            timeline.doc.should.have.property "list"
      
      UserTimeline.get_or_create("#{user2_key}#{UserTimeline::POSTFIX}")
        .then (timeline) ->
          timeline.key.should.be.equal "#{user2_key}#{UserTimeline::POSTFIX}"
          timeline.doc.should.have.property "list"

    it "should add item to timeline", ->
      user_key = "user3"
      user_timeline_key = "#{user_key}#{UserTimeline::POSTFIX}"
      activity = {
        doc_key: "a_1"
        title: "act 1"
      }

      UserTimeline.get_or_create(user_key)
        .then (timeline) ->
          timeline.add(activity, "activity")
        .then (res)->
          res.should.not.be.instanceof Error
          UserTimeline.get_or_create(user_key)
        .then (timeline) ->
          timeline.doc.list.should.have.length 1
          timeline.doc.list[0].should.contain.all.keys ['doc_key', 'name', 'type', 'at']
        .then ->
          UserTimeline.get(user_timeline_key)
        .then (timeline) ->
          timeline.doc.list.should.have.length 1
          timeline.doc.list[0].should.contain.all.keys ['doc_key', 'name', 'type', 'at']


