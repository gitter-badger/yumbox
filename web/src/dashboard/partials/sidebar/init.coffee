sys = window.sys

sys.partials.sidebar =
  name: 'partials.sidebar'
  dependencies: []
  controllers:
    base:
      name: 'sidebarCtrl'
      inject: [
        '$scope'
        '$rootScope'
        '$state'
        sys.modules.auth.services.authentication
        '$sessionStorage'
      ]

angular.module sys.partials.sidebar.name, sys.partials.sidebar.dependencies
