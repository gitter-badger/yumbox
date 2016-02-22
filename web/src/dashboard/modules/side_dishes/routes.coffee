module = window.sys.modules.side_dishes

states = ($stateProvider) ->
  $stateProvider
    .state( module.states.index.name, module.states.index.config)
    .state( module.states.new.name, module.states.new.config)
    .state( module.states.show.name, module.states.show.config)
    .state( module.states.edit.name, module.states.edit.config)

states.$inject = [ '$stateProvider' ]

angular.module( module.name ).config states
