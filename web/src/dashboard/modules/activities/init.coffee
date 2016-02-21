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
            'bower/angular-bootstrap-datetimepicker/src/css/datetimepicker.css'
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

sys.modules.activities =
  name: 'activities'
  dependencies: [
    'angularMoment'
    'angular-bootstrap-select'
    'angular-bootstrap-select.extra'
    'ui.bootstrap.datetimepicker'
    'angularFileUpload'
  ]
  constants: {}
  controllers:
    show:
      name: 'activitiesShowCtrl'
      inject: ['$scope', '$stateParams', '$http']
    index:
      name: 'activitiesIndexCtrl'
      inject: ['$scope', '$stateParams', '$http']
    form:
      name: 'activitiesFormCtrl'
      inject: ['$scope', '$state', '$http', '$timeout', 'FileUploader']
  services: {}
  directives: {}
  endpoints:
    list: '/api/v1/dashboard/activities'
    create: '/api/v1/dashboard/activities'
    get: '/api/v1/dashboard/activities/:id'
    update: '/api/v1/dashboard/activities/:id'
    images:
      add: '/api/v1/dashboard/activities/:id/images'
      remove: '/api/v1/dashboard/activities/:id/images/:name'
      main: '/api/v1/dashboard/activities/:id/images/:name/main'
  events: {}
  states:
    index:
      name: 'activities'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/activities'
        templateUrl: 'views/modules/activities/html/index'
    new:
      name: 'new_activity'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/activities/new'
        templateUrl: 'views/modules/activities/html/form'
        resolve: resolvers.form
    show:
      name: 'activity'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/activities/:id'
        templateUrl: 'views/modules/activities/html/show'
    edit:
      name: 'edit_activity'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/activities/:id/edit'
        templateUrl: 'views/modules/activities/html/form'
        resolve: resolvers.form

module = angular.module sys.modules.activities.name, sys.modules.activities.dependencies
