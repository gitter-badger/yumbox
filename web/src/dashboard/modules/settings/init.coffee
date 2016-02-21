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

sys.modules.settings = {
  name: 'modules.settings'
  dependencies: []
  controllers:
    base:
      name: 'settingsCtrl'
      inject: ['$scope', '$rootScope', '$state', '$stateParams', '$http', '$sessionStorage']
    profile:
      name: 'settingsProfileCtrl'
      inject: ['$scope', '$rootScope', '$http', '$timeout', 'FileUploader']
    password:
      name: 'settingsPasswordCtrl'
      inject: ['$scope', '$rootScope', '$http']
    plugins:
      name: 'settingsPluginsCtrl'
      inject: ['$scope', '$rootScope', '$http']
  states:
    show:
      name: 'settings'
      config:
        access: ['hostel']
        url: '/settings'
        templateUrl: 'views/modules/settings/html/base'
    profile:
      name: 'profile'
      config:
        access: ['hostel']
        url: '/settings/profile'
        templateUrl: 'views/modules/settings/html/profile'
        resolve: resolvers.form
    password:
      name: 'password'
      config:
        access: ['hostel']
        url: '/settings/password'
        templateUrl: 'views/modules/settings/html/password'
    plugins:
      name: 'plugins'
      config:
        access: ['hostel']
        url: '/settings/plugins'
        templateUrl: 'views/modules/settings/html/plugins'
  endpoints:
    profile: '/api/v1/dashboard/me'
    avatar: '/api/v1/dashboard/me/avatar'
    password: '/api/v1/dashboard/me/password'
    reset: '/api/v1/dashboard/me/api/:key/reset'
    api:
      get: '/api/v1/dashboard/me/api'
      update: '/api/v1/dashboard/me/api/:key'
    walkthrough: '/api/v1/dashboard/me/walkthrough'
    images:
      add: '/api/v1/dashboard/me/images'
      remove: '/api/v1/dashboard/me/images/:name'
      main: '/api/v1/dashboard/me/images/:name/main'
}

angular.module sys.modules.settings.name, sys.modules.settings.dependencies

