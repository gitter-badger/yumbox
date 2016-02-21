sys = window.sys

sys.modules.auth =
  name: 'auth'
  dependencies: ['ngStorage', sys.modules.home.name, 'ngAnimate']
  enums:
    requireSignin: 0
    authorised: 1
    unauthorised: 2
  services:
    authentication: 'authentication'
    authorisation: 'authorisation'
  directives:
    access: 'access'
  endpoints:
    login: '/api/v1/dashboard/login'
    signup: '/api/v1/dashboard/signup'
    session: '/api/v1/dashboard/session'
    logout: '/api/v1/dashboard/logout'
  events:
    loggedIn: 'auth:loggedIn'
    loggedOut: 'auth:loggedOut'
    sessionStarted: 'auth:sessionStarted'
  states:
    login:
      name: 'login'
      config:
        url: '/login'
        templateUrl: 'views/modules/auth/html/login'
        currentTab: 'login'
    forgot:
      name: 'forgot'
      config:
        url: '/forgot'
        templateUrl: 'views/modules/auth/html/login'
        currentTab: 'forgot'
    register:
      name: 'register'
      config:
        url: '/register'
        templateUrl: 'views/modules/auth/html/login'
        currentTab: 'register'
    unauthorised:
      name: 'unauthorised'
      config:
        url: '/unauthorised'
        templateUrl: 'views/modules/auth/html/unauthorised'

sys.modules.auth.controllers =
  base:
    name: 'loginCtrl'
    inject: [
      '$scope'
      '$rootScope'
      '$state'
      sys.modules.auth.services.authentication
      sys.modules.home.services.base.name
      '$localStorage'
      '$http'
    ]

angular.module sys.modules.auth.name, sys.modules.auth.dependencies
