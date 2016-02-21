module = window.sys.modules.auth

states = ($stateProvider) ->
  $stateProvider
    .state( module.states.login.name, module.states.login.config )
    .state( module.states.forgot.name, module.states.forgot.config )
    .state( module.states.register.name, module.states.register.config )
    .state( module.states.unauthorised.name, module.states.unauthorised.config )

states.$inject = [ '$stateProvider' ]

angular.module( module.name ).config states
