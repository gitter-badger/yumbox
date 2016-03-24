Boom    = require 'boom'
_       = require 'lodash'
Q       = require 'q'

module.exports = (server, options) ->
  return class Customer extends server.methods.model.Base()
    PREFIX: 'c'

    props:
      name: on
      mobile: on
      address: on

    @generate_pin: (mobile) ->
      @_get_by_mobile(mobile)
        .then (customer) ->
          return customer if customer is no
          pin = _.random(1000, 9999)
          customer.doc.recovery = { pin: pin , tries: 0 }
          customer.update()
            .then -> pin

    @verify_pin: (mobile, pin)->
      @_get_by_mobile(mobile)
        .then (customer) ->
          return customer if customer is no
          return no unless customer.doc.recovery?
          customer.doc.recovery.tries += 1
          if pin is customer.doc.recovery.pin and customer.doc.recovery.tries < options.defaults.verification.try
            delete customer.doc.recovery
            customer.update yes
          else
            customer.update().then -> no

    @_get_by_mobile: (mobile) ->
      query =
        body:
          query:
            term:
              mobile:
                value: mobile
      @search('customer', query)
        .then (answers) =>
          return Q no if answers.hits.total < 1
          @get(answers.hits.hits[0]._id)
