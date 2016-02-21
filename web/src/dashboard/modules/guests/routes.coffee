module = window.sys.modules.guests

states = ($stateProvider) ->
  $stateProvider
    .state( module.states.index.name, module.states.index.config )
    .state( module.states.show.name, module.states.show.config )

states.$inject = [ '$stateProvider' ]

angular.module( module.name ).config states
