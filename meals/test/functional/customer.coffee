chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'
moment   = require 'moment'

chai.use chaiHttp

describe 'meals', ->
  URL    = 'http://localhost:3100'

  it "should get meals", ->
    chai.request(URL)
      .get('/v1/api/dashboard/feed')
      .then( (res) ->
        res.should.have.status 200
        should.equal res.body.error, null
        # it should be an array
        # each item in feed reply shoud have following keys
        # res.body.data.should.have.keys 'doc_key', 'main_dish', 'side_dishes', 'total', 'remained', 'at'
      )

  it 'should fail get meals by range'

  it 'should get total and ramained'
