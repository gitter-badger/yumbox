sys = window.sys

service = (authentication) ->
  return {
    authorise: (permissions) ->
      result = sys.modules.auth.enums.authorised
      user = authentication.getCurrentUser()
      return true if permissions[0] == 'developer'
      return sys.modules.auth.enums.requireSignin if ! user?
      return if (user.role in permissions)
        sys.modules.auth.enums.authorised
      else
        sys.modules.auth.enums.unauthorised
    access: (permissions) ->
      user = authentication.getCurrentUser()
      role = if user?
        user.role
      else
        'guest'
      (role in permissions)
  }

service.$inject = [ sys.modules.auth.services.authentication ]

angular.module( sys.modules.auth.name ).factory sys.modules.auth.services.authorisation, service
