should      = require('chai').should()
_           = require 'lodash'
server      = require '../../../api/src/mock'
UserEmail   = require('../../src/models/user_email') server,
  defaults:
    verification:
      expiry: 15
      try: 1

moment      = require 'moment'
Q           = require 'q'

###
server.method 'bookings.to_guests_by_email', (user_email) ->
 Q [
  {
    "hostel_key": "h_EJGJAN1v",
    "from": "2015-07-21T18:02:26+04:30",
    "to": "2015-07-25T18:02:26+04:30",
    "reference_number": "b1_0",
    "doc_key": "g_4J5tSWpP"
  },
  {
    "hostel_key": "h_N1P-KtOP",
    "from": "2015-06-28T18:02:26+04:30",
    "to": "2015-06-30T18:02:26+04:30",
    "reference_number": "18_2",
    "doc_key": "g_4JRpZ2uv"
  }
 ]
###
describe 'UserEmail', ->
  
  USER_EMAIL =
    user_key: 'u_1'
    verification: 'dummy'
    auth: 'dummy'

  it "should only accept limited props", ->
    email_address = "0@0.com"
    email = new UserEmail email_address, USER_EMAIL
    email.doc.should.be.eql { user_key: 'u_1', doc_type: 'useremail', doc_key: 'e:0@0.com' }

  it "should always add prefix to email which is the key", ->
    email_address = "a@a.com"
    email = new UserEmail email_address, USER_EMAIL
    email.key.should.be.equal "#{UserEmail::PREFIX}:#{email_address}"
    email.doc.doc_key.should.be.equal email.key

  it "should generate auth and verification before create", ->
    email = new UserEmail "b@b.com", USER_EMAIL
    email.create().then (d) ->
      email.doc.should.include.keys 'verification', 'auth'
      email.doc.verification.should.include.keys 'code', 'expires_at'

  it "should load same auth and verification on loading from db", ->
    email_address = "c@c.com"
    email = new UserEmail email_address, USER_EMAIL
    email.create().then ->
      UserEmail.get("#{UserEmail::PREFIX}:#{email_address}").then (obj) ->
        email.doc.should.be.deep.equal obj.doc

  it "should get document by email", ->
    email_address = "d@d.com"
    email = new UserEmail email_address, USER_EMAIL
    email.create().then ->
      UserEmail.get_by_email(email_address).then (obj) ->
        email.doc.should.be.deep.equal obj.doc

  it "should fail on duplicated emails", ->
    email_address = "e@e.com"
    email = new UserEmail email_address, USER_EMAIL
    email.create().then ->
      email.create().then (doc) ->
        doc.output.statusCode.should.be.eql 409
  
  it "should fail if user does not own the email", ->
    email_address = "f@f.com"
    new_email_address = "ff@f.com"
    email = new UserEmail email_address, USER_EMAIL
    email.create().then (d)->
      UserEmail.change('someone_else', email_address, new_email_address).then (data) ->
        data.should.be.instanceof Error
  
  it "should replace email with new email if not verified", ->
    email_address = "f@f.com"
    new_email_address = "ff@f.com"
    email = new UserEmail email_address, USER_EMAIL
    email.create().then (d)->
      UserEmail.change(USER_EMAIL.user_key, email_address, new_email_address).then ->
        UserEmail.get_by_email(email_address).then (data) ->
          data.should.be.instanceof Error
  
  it "should replace email with new email and keep verified emails", ->
    email_address = "f@f.com"
    new_email_address = "ff@f.com"
    email = new UserEmail email_address, USER_EMAIL
    email.create().then (d)->
      email.doc.verification.verified_at = moment().format()
      email.update().then ->
        UserEmail.change(USER_EMAIL.user_key, email_address, new_email_address).then ->
          UserEmail.get_by_email(email_address).then (data) ->
            data.should.be.instanceof UserEmail
    
