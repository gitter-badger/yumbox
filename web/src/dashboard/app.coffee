sys = window.sys

app = angular.module sys.modules.app.name, [
  'angular-loading-bar'
  'oc.lazyLoad'
  'ui.router'

  'ui.bootstrap'
  'angulartics'
  'angulartics.google.analytics'
  'ngAnimate'
  'angularMoment'
  'ngClipboard'
  'btford.socket-io'
  'angular-chartist'
  'angular-cache'
  'ngMap'
  'infinite-scroll'
  'cfp.hotkeys'
  'focusOn'
  'angular-intro'
  sys.modules.guests.name
  sys.modules.bookings.name
  sys.modules.activities.name
  sys.modules.main_dishes.name
  sys.modules.side_dishes.name
  sys.modules.settings.name
  sys.modules.search.name
  sys.modules.console.name
  sys.modules.analytics.name
  sys.modules.home.name
  sys.modules.auth.name
  sys.partials.toolbar.name
  sys.partials.sidebar.name
]

socket = (socketFactory) ->
  socketFactory {
    ioSocket: io.connect(':' + window.sys.defaults.io.socket)
  }
socket.$inject = ['socketFactory']
app.factory sys.modules.app.factories.socket, socket

app.config [
  'ngClipProvider',
  (ngClipProvider) -> ngClipProvider.setPath('/bower/zeroclipboard/dist/ZeroClipboard.swf')
]

app.config [
  'hotkeysProvider',
  (hotkeysProvider) -> hotkeysProvider.includeCheatSheet = false
]

cache = ($http, CacheFactory) ->
  $http.defaults.cache = CacheFactory 'httpCache', {
    maxAge: 6 * 60 * 60 * 1000
    cacheFlushInterval: 24 * 60 * 60 * 1000
    deleteOnExpire: 'aggressive'
  }
cache.$inject = ['$http', 'CacheFactory']
app.run cache
