module = window.sys.modules.bookings

states = ($stateProvider) ->
  $stateProvider
    .state( module.states.index.name, module.states.index.config )

states.$inject = [ '$stateProvider' ]

angular.module( module.name ).config states
