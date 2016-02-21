sys = window.sys

app = angular.module( sys.modules.app.name )

states = ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise sys.modules.home.states.home.config.url
  $stateProvider
    .state(
      sys.modules.app.states.app.name,
      {
        abstract: true
        resolve:
          authorize: [
            sys.modules.auth.services.authentication,
            (authentication) ->
              console.log 'authenticating on first load'
              authentication.session()
          ]
        template: '<div ui-view />'
      }
    )
    .state( sys.modules.home.states.home.name , sys.modules.home.states.home.config )
    .state( sys.modules.app.states.panel.name, sys.modules.app.states.panel.config )
    .state( sys.modules.app.states.page.name, sys.modules.app.states.page.config )

states.$inject = [ '$stateProvider', '$urlRouterProvider' ]

app.config states
