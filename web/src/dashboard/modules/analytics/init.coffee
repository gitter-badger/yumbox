sys = window.sys

sys.modules.analytics =
  name: 'analytics'
  dependencies: []
  enums: {}
  controllers:
    base:
      name: 'analyticsCtrl'
      inject: ['$scope']
  services: {}
  directives: {}
  endpoints: {}
  events: {}
  states:
    show:
      name: 'analytics'
      config:
        access: ['hostel']
        url: '/analytics/:id'
        templateUrl: 'views/modules/analytics/html/base'

angular.module sys.modules.analytics.name, sys.modules.analytics.dependencies
