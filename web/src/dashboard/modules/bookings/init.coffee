sys = window.sys

sys.modules.bookings =
  name: 'bookings'
  dependencies: [
    'angularMoment'
    'ui.bootstrap.datetimepicker'
  ]
  constants: {}
  controllers:
    index:
      name: 'bookingsIndexCtrl'
      inject: ['$scope', '$stateParams', '$http']
  services: {}
  directives: {}
  endpoints:
    list: '/api/v1/dashboard/bookings'
    create: '/api/v1/dashboard/bookings'
    get: '/api/v1/dashboard/bookings/:id'
  events: {}
  states:
    index:
      name: 'bookings'
      config:
        access: ['hostel']
        url: '/bookings'
        templateUrl: 'views/modules/bookings/html/index'
        resolve:
          loadPlugin: [ '$ocLazyLoad', ($ocLazyLoad) ->
            $ocLazyLoad.load [
              {
                name: 'css'
                insertBefore: 'link'
                files: [
                  'bower/angular-bootstrap-datetimepicker/src/css/datetimepicker.css'
                ]
              }
            ]
          ]

module = angular.module sys.modules.bookings.name, sys.modules.bookings.dependencies
