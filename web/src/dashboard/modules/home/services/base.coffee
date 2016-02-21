module = window.sys.modules.home

service = ->
  return {
    homeState: module.states.home.name
  }

service.$inject = module.services.base.inject

angular.module( module.name ).factory module.services.base.name, service
