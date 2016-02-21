sys = window.sys

access = ($rootScope, authorisation) ->
  return {
    restrict: 'A'
    link: (scope, element, attrs) ->
      show = ->
        roles = attrs.access.split ','
        if roles.length > 0
          if authorisation.access roles
            element.removeClass 'hidden'
          else
            element.addClass 'hidden'
      $rootScope.$on sys.modules.auth.events.loggedIn, show
      $rootScope.$on sys.modules.auth.events.loggedOut, show
      show()
  }

access.$inject = ['$rootScope', sys.modules.auth.services.authorisation]

angular.module( sys.modules.auth.name ).directive sys.modules.auth.directives.access, access
