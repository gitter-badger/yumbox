module.exports = (server, options) ->

  return class PinMail extends server.methods.mail.Base()
    
    subject: "Tipi: Pin request"
    template: "/users/pin.jade"

