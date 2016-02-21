sys = window.sys

sys.modules.guests =
  name: 'guests'
  dependencies: [
    'angularMoment'
    'ui.bootstrap.datetimepicker'
  ]
  constants:
    reviews:
      list: ['approved', 'rejected']
      approved: 'approved'
      rejected: 'rejected'
      retry: 'retry'
  controllers:
    show:
      name: 'guestsShowCtrl'
      #inject is defined below
    index:
      name: 'guestsIndexCtrl'
      #inject is defined below
  services:
    guests:
      name: 'guestsService'
      inject: []
  directives: {}
  endpoints:
    list: '/api/v1/dashboard/guests'
    get: '/api/v1/dashboard/guests/:id'
    passport: '/api/v1/dashboard/users/:id/passport'
    checkin: '/api/v1/dashboard/guests/:id/checkin'
    checkout: '/api/v1/dashboard/guests/:id/checkout'
    activities:
      suggest: '/api/v1/dashboard/users/:id/activities/suggest'
      attend: '/api/v1/dashboard/activities/:id/attendees'
  events: {}
  states:
    index:
      name: 'guests'
      config:
        access: ['hostel']
        url: '/guests'
        templateUrl: 'views/modules/guests/html/index'
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
    show:
      name: 'guest'
      config:
        access: ['hostel']
        url: '/guests/:id?user_key'
        templateUrl: 'views/modules/guests/html/show'

sys.modules.guests.controllers.show.inject = [
  '$scope'
  '$stateParams'
  sys.modules.guests.services.guests.name
  '$http'
]
sys.modules.guests.controllers.index.inject = [
  '$scope'
  '$stateParams'
  sys.modules.guests.services.guests.name
  '$http'
]

module = angular.module sys.modules.guests.name, sys.modules.guests.dependencies

moment = (moment) ->
  moment.changeLocale 'en', {
    calendar:
      lastDay: '[Yesterday]'
      sameDay: '[Today]'
      nextDay: '[Tomorrow]',
      lastWeek: '[last] dddd',
      nextWeek: 'dddd',
      sameElse: 'L'
  }

moment.$inject = ['amMoment']

module.run moment
