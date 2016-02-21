sys = window.sys

sys.modules.home = {
  name: 'modules.home'
  dependencies: []
  constants:
    views:
      states:
        hidden: 'Hidden'
        loaded: 'Loaded'
        no_access: 'No Access'
        disabled: 'Disabled'
      activities:
        state: 'hidden'
      guests:
        state: 'hidden'
      analytics:
        state: 'hidden'
      bookings:
        state: 'hidden'
      feed:
        state: 'hidden'
      reviews:
        state: 'hidden'
  controllers:
    base:
      name: 'homeCtrl'
      inject: [
        '$scope'
        '$rootScope'
        '$state'
        '$stateParams'
        '$http'
        '$cacheFactory'
        sys.modules.guests.services.guests.name
        sys.modules.app.factories.socket
        '$sessionStorage'
        '$timeout'
      ]
  services:
    base:
      name: 'home'
      inject: []
  states:
    home:
      name: 'home'
      config:
        parent: sys.modules.app.states.app.name
        access: ['hostel']
        url: '/'
        templateUrl: 'views/modules/home/html/base'
  endpoints:
    checkins: '/api/v1/dashboard/guests/checkins'
    checkouts: '/api/v1/dashboard/guests/checkouts'
    activities: '/api/v1/dashboard/activities/upcoming'
    reviews:
      list: '/api/v1/dashboard/reviews?only_new=true'
      seen: '/api/v1/dashboard/reviews/:id/seen'
    guests:
      accept: '/api/v1/dashboard/guests/:id/accept'
      reject: '/api/v1/dashboard/guests/:id/reject'
      by_user: '/api/v1/dashboard/guests/user/:id'
    analytics:
      activities:
        overal: '/v1/analytics/me/activities'
      guests:
        overal: '/v1/analytics/me/guests'
        count: '/v1/analytics/me/guests/count'
}

angular.module sys.modules.home.name, sys.modules.home.dependencies
