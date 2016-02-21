module = window.sys.modules.console

states = ($stateProvider) ->
  $stateProvider
    .state( module.states.show.name, module.states.show.config)

states.$inject = [ '$stateProvider' ]

angular.module( module.name ).config states

