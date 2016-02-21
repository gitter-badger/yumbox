sys = window.sys

sys.modules.search = {
  name: 'modules.search'
  dependencies: []
  constants:
    limits:
      bookings: 6
      guests: 6
      activities: 4
  controllers:
    base:
      name: 'searchCtrl'
      inject: ['$scope', '$rootScope', '$state', '$stateParams', '$http', '$sessionStorage']
  states:
    show:
      name: 'search'
      config:
        access: ['hostel']
        url: '/search?q&s'
        reloadOnSearch: false
        templateUrl: 'views/modules/search/html/base'
  events:
    changed: 'search:changed'
  endpoints:
    list: '/api/v1/dashboard/activities'
    search: '/api/v1/dashboard/search'
}

angular.module sys.modules.search.name, sys.modules.search.dependencies
