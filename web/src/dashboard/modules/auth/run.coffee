sys = window.sys

runner = ($rootScope, $state, authorisation) ->
  $rootScope.$on '$stateChangeStart', (event, next) ->
    authorised = null
    if next.access?
      authorised = authorisation.authorise next.access
      $rootScope.logged_in = true
      if authorised == sys.modules.auth.enums.requireSignin
        console.log 'redirect to login'
        $rootScope.logged_in = false
        $state.go sys.modules.auth.states.login.name
      else if authorised == sys.modules.auth.enums.unauthorised
        $state.go sys.modules.auth.states.unauthorised.name

runner.$inject = ['$rootScope', '$state', sys.modules.auth.services.authorisation]

angular.module( sys.modules.auth.name ).run runner
