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

sys.modules.side_dishes =
  name: 'side_dishes'
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
      name: 'side_dishesShowCtrl'
      inject: ['$scope', '$stateParams', '$http']
    index:
      name: 'side_dishesIndexCtrl'
      inject: ['$scope', '$stateParams', '$http']
    form:
      name: 'side_dishesFormCtrl'
      inject: ['$scope', '$state', '$http', '$timeout', 'FileUploader']
  services: {}
  directives: {}
  endpoints:
    list: '/api/v1/dashboard/side_dishes'
    create: '/api/v1/dashboard/side_dishes'
    get: '/api/v1/dashboard/side_dishes/:id'
    update: '/api/v1/dashboard/side_dishes/:id'
    images:
      add: '/api/v1/dashboard/side_dishes/:id/images'
      remove: '/api/v1/dashboard/side_dishes/:id/images/:name'
      main: '/api/v1/dashboard/side_dishes/:id/images/:name/main'
  events: {}
  states:
    index:
      name: 'side_dishes'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/side_dishes'
        templateUrl: 'views/modules/side_dishes/html/index'
    new:
      name: 'new_side_dish'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/side_dishes/new'
        templateUrl: 'views/modules/side_dishes/html/form'
        resolve: resolvers.form
    show:
      name: 'side_dish'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/side_dishes/:id'
        templateUrl: 'views/modules/side_dishes/html/show'
    edit:
      name: 'edit_side_dish'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/side_dishes/:id/edit'
        templateUrl: 'views/modules/side_dishes/html/form'
        resolve: resolvers.form

module = angular.module sys.modules..name, sys.modules.side_dishes.dependencies
