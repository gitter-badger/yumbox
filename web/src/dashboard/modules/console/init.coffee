sys = window.sys

resolvers =
  form:
    loadPlugin: [ '$ocLazyLoad', ($ocLazyLoad) ->
      $ocLazyLoad.load [
        {
          name: 'css'
          insertBefore: 'link'
          files: [
            'bower/bootstrap-select/dist/css/bootstrap-select.min.css'
            '/assets/css/json.css'
          ]
        }
        {
          name: 'vendors'
          files: [
            'bower/bootstrap-select/dist/js/bootstrap-select.min.js'
          ]
        }
      ]
    ]

sys.modules.console = {
  name: 'modules.console'
  dependencies: ['ngPrettyJson']
  controllers:
    base:
      name: 'consoleCtrl'
      inject: ['$scope', '$rootScope', '$state', '$stateParams', '$http']
  events:
    search: 'console:search'
    choose: 'console:choose'
  states:
    show:
      name: 'console'
      config:
        access: ['developer']
        url: '/console/:key'
        templateUrl: 'views/modules/console/html/base'
        resolve: resolvers.form
  endpoints:
    console: '/api/v1/developer/booking'
}

angular.module sys.modules.console.name, sys.modules.console.dependencies

