module = window.sys.modules.settings

states = ($stateProvider) ->
  $stateProvider
    .state( module.states.show.name, module.states.show.config)
    .state( module.states.profile.name, module.states.profile.config)
    .state( module.states.password.name, module.states.password.config)
    .state( module.states.plugins.name, module.states.plugins.config)

states.$inject = [ '$stateProvider' ]

angular.module( module.name ).config states

