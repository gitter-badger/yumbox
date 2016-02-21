window.sys ||= {}
angular.extend window.sys, {
  modules:
    app:
      name: 'tipi'
      controllers:
        base:
          name: 'ApplicationCtrl'
          inject: [
            '$scope'
            '$rootScope'
            '$state'
            'hotkeys'
            '$modal'
            '$http'
            '$sessionStorage'
          ]
      factories:
        socket: 'socket.io'
      events:
        loading: 'app:loading'
        completed: 'app:completed'
        walkthrough:
          skipped: 'walkthrough:skipped'
      states:
        app:
          name: 'app'
          config: 'CHECK ROUTE.COFFEE'
        panel:
          name: 'panel'
          config:
            url: '/:page'
            templateUrl: ($stateParams) -> 'views/modules/#{$stateParams.page}/html/base'
        page:
          name: 'page'
          config:
            url: '/panel/:page'
            templateUrl: ($stateParams) -> 'views/modules/#{$stateParams.page}/html/admin'
      endpoints:
        walkthrough: '/api/v1/dashboard/me/walkthrough'
  partials: {}
}
