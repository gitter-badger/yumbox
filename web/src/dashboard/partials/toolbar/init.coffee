sys = window.sys

sys.partials.toolbar =
  name: 'partials.toolbar'
  dependencies: []
  enums:
    normal: 'normal'
    search: 'search'
    console: 'console'
  controllers:
    base:
      name: 'toolbarCtrl'
      inject: [
        '$scope'
        '$rootScope'
        '$state'
        '$stateParams'
        '$http'
        sys.modules.auth.services.authentication
        '$sessionStorage'
        'hotkeys'
        'focus'
        '$modal'
      ]
  endpoints:
    shoutout: '/api/v1/dashboard/shoutout'

angular.module sys.partials.toolbar.name, sys.partials.toolbar.dependencies
