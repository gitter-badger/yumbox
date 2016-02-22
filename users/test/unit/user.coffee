should      = require('chai').should()
_           = require 'lodash'
server      = require '../../../api/src/mock'
User        = require('../../src/models/user') server,
  defaults:
    verification:
      expiry: 15
UserProfile = require('../../src/models/user_profile') server, {}, User
UserEmail   = require('../../src/models/user_email') server,
  defaults:
    verification:
      expiry: 15
moment      = require 'moment'
Q           = require  'q'

unless server.methods.bookings?.to_guests_by_email?
  server.method 'bookings.to_guests_by_email', (email) ->
    Q(true)


describe 'User', ->
  
  EMAIL = "arash@tipi.me"
  USER =
    email: EMAIL
    name: "Arash"
    gender: 1
    age: "25"
    city: "Tehran"
    country: "Iran"
    last_location: { latitude: 1, longitude: 2 }
    last_seen_at: "Should not get set"
    avatar: "#{__dirname}/images/avatar.jpg"

  it "should have constants", ->
    User::AVATAR.SMALL.should.be.equal 'savatar'
    User::AVATAR.MEDIUM.should.be.equal 'mavatar'
    User::IMAGE_SIZE.SMALL.should.be.an 'array'
    User::IMAGE_SIZE.MEDIUM.should.be.an 'array'

  it "should only accept limited props", ->
    user = new User USER
    user_data = _.merge {}, USER, { doc_key: user.key, doc_type: user.doc_type }
    delete user_data.last_seen_at
    delete user_data.age
    delete user_data.email
    user.doc.should.be.deep.equal user_data

  it "should not expose last_seen_at", ->
    user = new User USER
    user.doc.last_seen_at = new Date
    user.mask().should.not.have.property('last_seen_at')
    user.mask(['last_seen_at']).should.have.property('last_seen_at')

  it "should set @avatar attribute", ->
    user = new User USER
    user.should.have.property 'avatar'
    user.doc.avatar.should.be.equal USER.avatar
  
  it "should exclude avatar on create and update from doc", ->
    user = new User _.extend {}, USER
    user.doc.should.have.property 'avatar'
    user.create().then ->
      user.doc.should.not.have.property 'avatar'
      user.doc.avatar = USER.avatar
      user.update()
        .then ->
          user.doc.should.not.have.property 'avatar'
        .done()

  it "should create user with no profile params passed", ->
    email_address = "u1@tipi.me"
    user = new User USER
    user.email_address = email_address
    user.create()
      .then (o) ->
        User.get(user.key)
          .then (obj) ->
            obj.doc.doc_key.should.be.equal user.key
            UserEmail.get("#{UserEmail::PREFIX}:#{email_address}")
              .then (obj) ->
                obj.doc.doc_key.should.be.equal "#{UserEmail::PREFIX}:#{email_address}"
                UserProfile.get_by_user(user.key)
                  .then (obj) ->
                    obj.doc.doc_key.should.be.equal "#{user.key}#{UserProfile::POSTFIX}"

  it "should create user with email doc and profile doc", ->
    email_address = "u2@tipi.me"
    user = new User USER
    user.email_address = email_address
    user.profile = USER
    user.create()
      .then (o) ->
        User.get(user.key)
          .then (obj) ->
            obj.doc.doc_key.should.be.equal user.key
            UserEmail.get("#{UserEmail::PREFIX}:#{email_address}")
              .then (obj) ->
                obj.doc.doc_key.should.be.equal "#{UserEmail::PREFIX}:#{email_address}"
                UserProfile.get_by_user(user.key)
                  .then (obj) ->
                    obj.doc.doc_key.should.be.equal "#{user.key}#{UserProfile::POSTFIX}"

  it "should calculate and add age of user from dob of his profile on user creation", ->
    email_address = "u3@tipi.me"
    user = new User USER
    user.email_address = email_address
    user.profile = USER

    age = 32
    dob = moment().subtract(age,'y').toDate()

    user.profile.dob = dob
    user.create()
      .then (o) ->
        User.get(user.key)
          .then (obj) ->
            obj.doc.should.have.property 'age'
            obj.doc.age.should.be.closeTo age, 1
            UserProfile.get_by_user(user.key)
              .then (obj) ->
                obj.doc.dob.should.be.equal moment(dob).toISOString()

  it "should calculate and update age of user from dob of his profile on profile edit", ->
    email_address = "u4@tipi.me"
    user = new User USER
    user.email_address = email_address
    user.profile = USER

    age = 32
    dob = moment().subtract(age,'y').toDate()

    edited_age = 30
    edited_dob = moment().subtract(edited_age,'y').toDate()

    user.profile.dob = dob
    user.create()
      .then (o) ->
        UserProfile.get_by_user(user.key).then (edited_profile) ->
          edited_profile.doc.dob = edited_dob
          edited_profile.update()
            .then ->
              UserProfile.get_by_user(user.key)
                .then (obj) ->
                  obj.doc.dob.should.be.equal moment(edited_dob).toISOString()
            .then ->
              User.get(user.key)
                .then (obj) ->
                  obj.doc.age.should.be.closeTo edited_age, 1

  it "should fail if email address already exists", ->
    email_address = "u1@tipi.me"
    email = new UserEmail email_address, { user_key: 'u_1' }
    email.create().then ->
      user = new User USER
      user.email_address = email_address
      user.profile = USER
      user.create()
        .then (obj) ->
          obj.should.be.an.instanceof Error
   
  it "should create image file on create and update", false

  it "should get profile when user is created with required fields", ->
    user_data = { name: 'Arash', email: "u5@tipi.me", avatar: "#{__dirname}/images/avatar.jpg" }
    user = new User user_data
    user.email_address = user_data.email
    user.profile = user_data
    user.create()
      .then (o) ->
        UserProfile.get_for_edit(user.key)
          .then (profile) ->
            profile.should.contain.keys 'passport'
            profile.passport.is_updatable.should.be.eql true

