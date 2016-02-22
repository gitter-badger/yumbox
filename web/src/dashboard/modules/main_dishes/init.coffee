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

sys.modules.main_dishes =
  name: 'main_dishes'
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
      name: 'main_dishesShowCtrl'
      inject: ['$scope', '$stateParams', '$http']
    index:
      name: 'main_dishesIndexCtrl'
      inject: ['$scope', '$stateParams', '$http']
    form:
      name: 'main_dishesFormCtrl'
      inject: ['$scope', '$state', '$http', '$timeout', 'FileUploader']
  services: {}
  directives: {}
  endpoints:
    list: '/api/v1/dashboard/main_dishes'
    create: '/api/v1/dashboard/main_dishes'
    get: '/api/v1/dashboard/main_dishes/:id'
    update: '/api/v1/dashboard/main_dishess/:id'
    images:
      add: '/api/v1/dashboard/main_dishes/:id/images'
      remove: '/api/v1/dashboard/main_dishes/:id/images/:name'
      main: '/api/v1/dashboard/main_dishes/:id/images/:name/main'
  events: {}
  states:
    index:
      name: 'main_dishes'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/main_dishes'
        templateUrl: 'views/modules/main_dishes/html/index'
    new:
      name: 'new_main_dish'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/main_dishes/new'
        templateUrl: 'views/modules/main_dishes/html/form'
        resolve: resolvers.form
    show:
      name: 'main_dish'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/main_dishes/:id'
        templateUrl: 'views/modules/main_dishes/html/show'
    edit:
      name: 'edit_main_dish'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/main_dishes/:id/edit'
        templateUrl: 'views/modules/main_dishes/html/form'
        resolve: resolvers.form

module = angular.module sys.modules.main_dishes.name, sys.modules.main_dishes.dependencies
