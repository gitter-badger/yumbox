_ = require "lodash"
Q = require "q"
request = require 'request'

module.exports = (server, options) ->
  return class Country extends server.methods.model.Base()

    PREFIX: 'country'

    props:
      name: true
      cities: true
      codes: true

    before_create: ->
      @doc.uname = _.snakeCase @doc.name
      cities = []
      for city in @doc.cities
        cities.push { name: city, code: "#{@doc.uname}_#{_.snakeCase city}" }
      @doc.cities = cities
      true

    _key: -> "#{Country::PREFIX}_#{_.snakeCase @doc.name}"

    @suggest: (q) ->
      key = "city_suggestions_#{q}"
      cache = server.plugins['hapi-redis'].client
      deferred = Q.defer()

      cache.get key, (error, reply) =>
        return deferred.reject new Error error if error
        return deferred.resolve JSON.parse reply if reply
        @_query(q)
          .then (results) ->
            cache.set key, JSON.stringify results
            deferred.resolve results
      return deferred.promise

    # This is based on http://www.geonames.org/export/geonames-search.html as a temporary solution
    # login to the service using tipi/yxshape at http://www.geonames.org/login
    @_query: (q) ->
      deferred = Q.defer()

      request(
        "http://api.geonames.org/searchJSON?name_startsWith=#{q}&maxRows=20&username=tipi&orderby=relevance&featureClass=p&featureCode=PPLC&featureCode=PPL&featureCode=PPLA",
        {
          json: true
        },
        (error, response, body) ->
          return deferred.reject new Error error if !(!error && response.statusCode == 200)
          answers = []
          _.each body.geonames, (v, k) ->
            answers.push {
              name: v.countryName
              cities: [v.name]
            }
          deferred.resolve answers
      )
      return deferred.promise
