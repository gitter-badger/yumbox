Path = require 'path'
Jade = require 'jade'
_    = require 'lodash'

module.exports = (server, options) ->
  return {
    users:
      verify: (request, reply) ->
        server.methods.users.verify_email(request.query.email, request.query.token)
          .then (data) ->
            error = null
            error = data.message if data instanceof Error
            reply.view 'app/emails/verify', { error: error, email: request.query.email }

      pin: (request, reply) ->
        reply.view 'app/emails/pin', { pin: request.params.pin }

    plugins:
      load: (request, reply) ->
        reply.file Path.join(__dirname, 'plugins', 'loader.js')

      guests: (request, reply) ->
        server.methods.hostel_browser_api.with_guests(request.query.uid)
          .then (api) ->
            configs =  api.settings.guests
            if request.query.demo?
              _.each configs, (n, k) ->
                v = request.query[k]
                return true unless v?
                v = v == 'true' if k in ['dark']
                configs[k] = v
                true
            data = { guests: api.guests, url: options.config.url, configs: configs }
            if request.query.jsonp?
              page = Jade.compileFile(Path.join(__dirname, 'plugins/guests.jade')) data
              reply.cross_html request.query.callback, page
            else
              reply.view 'plugins/guests', data
  }
