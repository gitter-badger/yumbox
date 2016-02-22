config   = require("#{__dirname}/../../../api/src/config/config").config
chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
fs       = require 'fs'
Q        = require 'q'
server   = require '../../../api/src/mock'

UserEmail   = require('../../src/models/user_email') server,
  defaults:
    verification:
      expiry: 15
      try: 1


chai.use chaiHttp

describe 'User', ->

  URL  = "#{config.server.api.host}:#{config.server.api.port}"
  USER =
    name: 'John Connor'
    email: 'john.connor@gmail.com'
    avatar: "#{__dirname}/images/avatar.jpg"
    passport:
      scan: "#{__dirname}/images/scan.jpg"
    version: 1
    device: 'android'

  it 'should sign up', ->
    chai.request(URL)
      .post('/v1/users/signup')
      .field( 'email', USER.email )
      .field( 'name', USER.name )
      .field( 'version', USER.version )
      .field( 'device', USER.device )
      .attach( 'avatar', fs.createReadStream(USER.avatar) )
      .then (res) ->
        res.should.have.status 200
        res.body.data.should.have.all.keys 'name', 'verification_progress', 'doc_key', 'auth'
        res.body.data.should.have.property('verification_progress').and.equal 0

  it 'should fail at sign up with taken email', ->
    chai.request(URL)
      .post('/v1/users/signup')
      .field( 'email', USER.email )
      .field( 'name', USER.name )
      .field( 'version', USER.version )
      .field( 'device', USER.device )
      .attach( 'avatar', fs.createReadStream(USER.avatar) )
      .then (res) ->
        res.should.have.status 409

  it 'should have verification progress equals 0', ->
    chai.request(URL)
      .post('/v1/users/signup')
      .field( 'email', "GlaHquq0_#{USER.email}" )
      .field( 'name', USER.name )
      .field( 'version', USER.version )
      .field( 'device', USER.device )
      .attach( 'avatar', fs.createReadStream(USER.avatar) )
      .then (res) ->
        res.should.have.status 200
        res.body.data.verification_progress.should.be.equal 0

  it 'should have verification progress equals 45', ->
    chai.request(URL)
      .post('/v1/users/signup')
      .field( 'email', "oAyzHDde_#{USER.email}" )
      .field( 'name', USER.name )
      .field( 'version', USER.version )
      .field( 'device', USER.device )
      .attach( 'passport[scan]',  fs.createReadStream(USER.passport.scan) )
      .attach( 'avatar', fs.createReadStream(USER.avatar) )
      .then (res) ->
        res.should.have.status 200
        res.body.data.verification_progress.should.be.equal 45
  
  it 'should have verification progress equals 5 and 10', ->
    agent = chai.request.agent URL
    agent.post('/v1/users/signup')
      .field( 'email', "social_#{USER.email}" )
      .field( 'name', USER.name )
      .field( 'version', USER.version )
      .field( 'device', USER.device )
      .attach( 'avatar', fs.createReadStream(USER.avatar) )
      .then (res) ->
        agent.post('/v1/me/edit')
          .field( 'fb_token', 2 )
          .then (res) ->
            res.should.have.status 200
            res.body.data.verification_progress.should.be.equal 5
            agent.post('/v1/me/edit')
              .field( 'g_token', 2 )
              .then (res) ->
                res.should.have.status 200
                res.body.data.verification_progress.should.be.equal 10
    
  it 'should have verification progress equals 15', ->
    agent = chai.request.agent URL
    email = "verify_email#{USER.email}"
    agent.post('/v1/users/signup')
      .field( 'email', email)
      .field( 'name', USER.name )
      .field( 'version', USER.version )
      .field( 'device', USER.device )
      .attach( 'avatar', fs.createReadStream(USER.avatar) )
      .then (res) ->
        agent.get('/v1/test/users/verification_code')
          .then (res) ->
            res.body.data
      .then (token) ->
        url  = "#{config.server.web.host}:#{config.server.web.port}"
        chai.request(url)
          .get('/app/verify')
          .query({'email': email, token: token})
      .then () ->
        agent.get('/v1/me/profile')
      .then (res) ->
        res.should.have.status 200
        res.body.data.verification_progress.should.be.equal 15
       
  it 'should accept only valid interests', -> false
    # All 12 interests are tested in 3 calls, each call validates 4 interests
