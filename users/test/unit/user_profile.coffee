should      = require('chai').should()
_           = require 'lodash'
server      = require '../../../api/src/mock'

Guest       = require('../../../hostels/src/models/guest') server, {}
UserEmail   = require('../../src/models/user_email') server,
  defaults:
    verification:
      expiry: 15
      try: 1

User        = require('../../src/models/user') server,
  defaults:
    verification:
      expiry: 15
      try: 1
UserProfile = require('../../src/models/user_profile') server,
  defaults:
    verification:
      expiry: 15
      try: 1
  , User
Q           = require 'q'
moment      = require 'moment'

unless server.methods.bookings?.to_guests_by_email?
  server.method 'bookings.to_guests_by_email', (email) ->
    Q(true)
unless server.methods.users?.notify?
  server.method 'users.notify', -> Q true

describe 'UserProfile', ->
  
  EMAIL = "arash@tipi.me"
  USER_KEY = "user1"
  USER_EMAIL =
    user_key: USER_KEY
  USER =
    name: "Arash"
    avatar: "#{__dirname}/images/avatar.jpg"
  PROFILE =
    interests: [ "wfi_hunter", "geek" ]
    dob: moment().subtract(20, 'year').format()
    passport:
      number: "123456"
      expires_at: moment().add(2, 'year').format()
      scan: "#{__dirname}/images/avatar.jpg"
      updated_at: "bad data"
      review: "bad data"
    insurance_dismissed_at: moment().format()
    fb_token: 1
    g_token: 2
    verification_progress: 10
    analysed_interests: [ "bad data" ]

  describe 'class structure', ->
    it "should only accept limited props", ->
      profile = new UserProfile USER_KEY, PROFILE
      profile_data = _.merge {}, PROFILE, { doc_key: profile.key, doc_type: profile.doc_type }
      delete profile_data.verification_progress
      delete profile_data.analysed_interests
      delete profile_data.device_verification
      delete profile_data.email
      profile.doc.should.be.deep.equal profile_data

  describe 'create', ->
    it "should create a profile and exclude passport scan", ->
      email = new UserEmail EMAIL, USER_EMAIL
      email.create().then (d)->
        profile = new UserProfile USER_KEY, _.cloneDeep PROFILE
        profile.doc.email = EMAIL
        profile.create()
          .then (data)->
            UserProfile.get_by_user(USER_KEY, true)
          .then (obj) ->
            obj.value.should.be.eql profile.doc
            obj.value.should.not.have.deep.property 'passport.scan'
            obj.value.should.contain.keys ['passport', 'email']
            obj.value.passport.should.contain.keys ['review', 'uid']
            obj.value.passport.review.should.be.eql { status: 'pending' }

  describe 'edit', ->
    it "should update email with email_doc", ->
      email_address = 'up1@gmail.com'
      user_key      = 'up1_user'
      user_email    = { user_key: user_key }
      new_profile   = { email: 'up2@gmail.com' }

      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, _.cloneDeep PROFILE
        profile.doc.email = email_address
        profile.create()
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile)->
            profile.check_and_update(new_profile)
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile)->
            profile.doc.email.should.be.eql new_profile.email

    it "should update age", ->
      # This test is in test/user.coffee
      true

    it "should update passport only if its expired or not approved", ->
      email_address   = 'ups1@gmail.com'
      user_key        = 'ups1_user'
      user_email      = { user_key: user_key }
      new_profile     = { passport: { scan: PROFILE.passport.scan } }

      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, _.cloneDeep PROFILE
        profile.doc.email = email_address
        profile.create()
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile)->
            first_uid = profile.doc.passport.uid
            profile.check_and_update(new_profile)
              .then ->
                UserProfile.get_by_user(user_key)
              .then (profile)->
                second_uid = profile.doc.passport.uid
                second_uid.should.not.be.eql first_uid
                profile.doc.passport.review.should.include { status: 'pending' }
                profile.doc.passport.review.status = UserProfile::PASSPORT_STATUS.APPROVED
                profile.check_and_update(new_profile)
                  .then ->
                    UserProfile.get_by_user(user_key)
                  .then (profile)->
                    profile.doc.passport.uid.should.be.eql second_uid
                    profile.doc.passport.expires_at = moment().subtract(2, 'day').format()
                    profile.check_and_update(new_profile)
                      .then ->
                        UserProfile.get_by_user(user_key)
                      .then (profile)->
                        profile.doc.passport.uid.should.not.be.eql second_uid

    it "should update passport only if its expired or not approved with passport number and expiry date", ->
      email_address   = 'ups1_2@gmail.com'
      user_key        = 'ups1_2_user'
      user_email      = { user_key: user_key }
      new_profile     = { passport: number: 123321123}

      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, _.cloneDeep PROFILE
        profile.doc.email = email_address
        profile.create()
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile)->
            first_uid = profile.doc.passport.uid
            profile.check_and_update(new_profile)
              .then ->
                UserProfile.get_by_user(user_key)
              .then (profile)->
                profile.doc.passport.number.should.be.eq new_profile.passport.number
                second_uid = profile.doc.passport.uid
                second_uid.should.not.be.eql first_uid
                profile.doc.passport.review.should.include { status: 'pending' }
                profile.doc.passport.review.status = UserProfile::PASSPORT_STATUS.APPROVED
                profile.check_and_update(new_profile)
                  .then ->
                    UserProfile.get_by_user(user_key)
                  .then (profile)->
                    profile.doc.passport.uid.should.be.eql second_uid
                    profile.doc.passport.expires_at = moment().subtract(2, 'day').format()
                    profile.check_and_update(new_profile)
                      .then ->
                        UserProfile.get_by_user(user_key)
                      .then (profile)->
                        profile.doc.passport.uid.should.not.be.eql second_uid
  describe "approve/reject passport", ->
    it "should approve passport", ->
      email_address   = 'up2@gmail.com'
      user_key        = 'up2_user'
      user_email      = { user_key: user_key }
      hostel_key      = "h_1"

      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, _.cloneDeep PROFILE
        profile.doc.email = email_address
        profile.create()
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile) ->
            profile.confirm_passport(hostel_key, yes)
          .then (result) ->
            result.should.not.be instanceof Error
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile) ->
            profile.doc.passport.review.status.should.be.eq profile.PASSPORT_STATUS.APPROVED

    it "should reject passport", ->
      email_address   = 'up3@gmail.com'
      user_key        = 'up3_user'
      user_email      = { user_key: user_key }
      hostel_key      = "h_1"

      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, _.cloneDeep PROFILE
        profile.doc.email = email_address
        profile.create()
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile) ->
            profile.confirm_passport(hostel_key, no)
          .then (result) ->
            result.should.not.be instanceof Error
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile) ->
            profile.doc.passport.review.status.should.be.eq profile.PASSPORT_STATUS.REJECTED

    it "should raise error on wrong passport confirmation status", ->
      email_address   = 'up4@gmail.com'
      user_key        = 'up4_user'
      user_email      = { user_key: user_key }
      hostel_key      = "h_1"

      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, _.cloneDeep PROFILE
        profile.doc.email = email_address
        profile.create()
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile) ->
            profile.confirm_passport(hostel_key, "yes")
          .then (result) ->
            result.should.be instanceof Error
          .then ->
            UserProfile.get_by_user(user_key)
          .then (profile) ->
            profile.doc.passport.review.status.should.be.eq profile.PASSPORT_STATUS.PENDING

    it "should get profile when user is created with required fields", ->
      # This test is in test/user.coffee
      true

  describe "calculate verification", ->
    it "should have verification progress equals 0", ->
      email_address   = 'up5@gmail.com'
      user_key        = 'up5_user'
      user_email      = { user_key: user_key }
      profile_data    =  _.clone PROFILE
      
      delete profile_data.passport
      delete profile_data.fb_token
      delete profile_data.g_token
      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, profile_data
        profile.doc.email = email_address
        profile.create()
          .then ->
            profile.doc.verification_progress.should.be.eq 0

    it "should have verification progress equals 45", ->
      email_address   = 'up6@gmail.com'
      user_key        = 'up6_user'
      user_email      = { user_key: user_key }
      profile_data    =  _.clone PROFILE
      
      delete profile_data.passport
      delete profile_data.fb_token
      delete profile_data.g_token
      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, profile_data
        profile.doc.email = email_address
        profile.create()
          .then ->
            profile.doc.verification_progress.should.be.eq 0
            profile.doc.passport = _.clone PROFILE.passport
            profile.update(true)
              .then (res) ->
                res.verification_progress.should.be.eq 45
    
    it "should have verification progress equals 5 and 10", ->
      email_address   = 'up7@gmail.com'
      user_key        = 'up7_user'
      user_email      = { user_key: user_key }
      profile_data    =  _.clone PROFILE
      
      delete profile_data.passport
      delete profile_data.fb_token
      delete profile_data.g_token
      email = new UserEmail email_address, user_email
      email.create().then (d)->
        profile = new UserProfile user_key, profile_data
        profile.doc.email = email_address
        profile.create()
          .then ->
            profile.doc.verification_progress.should.be.eq 0
            profile.doc.fb_token= _.clone PROFILE.fb_token
            profile.update(true)
              .then (res) =>
                res.verification_progress.should.be.eq 5
                profile.doc.g_token = _.clone PROFILE.g_token
                profile.update(true)
                  .then (res) ->
                    res.verification_progress.should.be.eq 10

    it "should have verification progress equals 15", ->
      email_address   = 'up8@gmail.com'
      user_key        = 'up8_user'
      user_email      = { user_key: user_key }
      profile_data    =  _.clone PROFILE
      
      delete profile_data.passport
      delete profile_data.fb_token
      delete profile_data.g_token
      email = new UserEmail email_address, user_email
      email.create().then (d)->
        email.doc.verification.verified_at = moment()
        email.update(true)
          .then (res) ->
            profile = new UserProfile user_key, profile_data
            profile.doc.email = email_address
            profile.create()
              .then ->
                profile.doc.verification_progress.should.be.eq 15
