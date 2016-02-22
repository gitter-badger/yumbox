config   = require("#{__dirname}/../../../api/src/config/config").config
chai     = require 'chai'
should   = chai.should()
chaiHttp = require 'chai-http'
_        = require 'lodash'
Q        = require 'q'

chai.use chaiHttp

describe 'Country', ->

  URL  = "#{config.server.api.host}:#{config.server.api.port}"
  COUNTRY =
    name: 'Planet'
    cities: [
      'Palaglosie'
      'Palaglomus'
      'Hubos'
      'Clecurus'
    ]

  it 'should list countries with cities', ->
    chai.request(URL)
      .get('/v1/countries/suggest')
      .query({ q: 'sydney' })
      .then( (res) ->
        res.body.data[0].should.have.property('cities').and.be.eql [ 'Sydney' ]
        res.should.have.status 200
      )
