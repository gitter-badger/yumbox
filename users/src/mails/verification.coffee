module.exports = (server, options) ->

  return class VerificationMail extends server.methods.mail.Base()
    
    subject: "Tipi: Verify your email"
    template: "/users/verification.jade"

