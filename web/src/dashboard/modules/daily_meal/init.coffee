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

sys.modules.daily_meal =
  name: 'modules.daily_meal'
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
      name: 'daily_mealShowCtrl'
      inject: ['$scope', '$stateParams', '$http']
    index:
      name: 'daily_mealIndexCtrl'
      inject: ['$scope', '$stateParams', '$http']
    form:
      name: 'daily_mealFormCtrl'
      inject: ['$scope', '$state', '$http', '$timeout', 'FileUploader']
  services: {}
  directives: {}
  endpoints:
    list: '/api/v1/dashboard/daily_meal'
    create: '/api/v1/dashboard/daily_meal'
    get: '/api/v1/dashboard/daily_meal/:id'
    update: '/api/v1/dashboard/daily_meal/:id'
    get_main_dishes: '/api/v1/dashboard/main_dishes'
    get_side_dishes: '/api/v1/dashboard/side_dishes'
    images:
      add: '/api/v1/dashboard/daily_meal/:id/images'
      remove: '/api/v1/dashboard/daily_meal/:id/images/:name'
      main: '/api/v1/dashboard/daily_meal/:id/images/:name/main'
  events: {}
  states:
    index:
      name: 'daily_meals'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/daily_meal'
        templateUrl: 'views/modules/daily_meal/html/index'
    new:
      name: 'new_daily_meal'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/daily_meal/new'
        templateUrl: 'views/modules/daily_meal/html/form'
        resolve: resolvers.form
    show:
      name: 'daily_meal'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/daily_meal/:id'
        templateUrl: 'views/modules/daily_meal/html/show'
    edit:
      name: 'edit_daily_meal'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/daily_meal/:id/edit'
        templateUrl: 'views/modules/daily_meal/html/form'
        resolve: resolvers.form

module = angular.module sys.modules.daily_meal.name, sys.modules.daily_meal.dependencies
