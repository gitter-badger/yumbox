sys = window.sys
module = window.sys.modules.auth

service = ($rootScope, $q, $http, $sessionStorage, $state, $location) ->
  storage = $sessionStorage.$default( { currentUser: null } )

  logged = (user) ->
    storage.currentUser = user
    $rootScope.$broadcast module.events.loggedIn, storage.currentUser
    $rootScope.$broadcast module.events.sessionStarted, storage.currentUser

  login = (email, password) ->
    defer = $q.defer()
    $http.post( module.endpoints.login, { email: email, password: password } ).then(
      (response) ->
        if response instanceof Error
          defer.reject 'Wrong email or password. Please try again.'
        else
          logged response.data.data
          defer.resolve storage.currentUser
        defer.promise
      , (e) ->
        switch e.status
          when 0 then defer.reject 'Cannot connect to server. Please try again later.'
          when 400 then defer.reject 'Please enter both email and password.'
          when 401 then defer.reject 'Wrong email or password. Please try again.'
        defer.promise
    )

  methods = {
    login: login
    logged: logged
    session: ->
      $http.get(module.endpoints.session, { cache: false } )
        .then (response) ->
          $rootScope.logged_in = true
          if response.data.data.success
            storage.currentUser = response.data.data
            $rootScope.$broadcast module.events.sessionStarted, storage.currentUser
          else
            console.log 'No session'
            session_required_urls = [
              module.states.forgot.config.url
              module.states.register.config.url
            ]
            unless session_required_urls.indexOf($location.path()) > -1
              $rootScope.logged_in = false
              console.log 'yoooooooooooooooooooo'
              $state.go 'login'
    logout: ->
      $http.post( module.endpoints.logout )
        .then ->
          storage.currentUser = null
          $rootScope.$broadcast module.events.loggedOut
          $state.go module.states.login.name
    getCurrentUser: -> storage.currentUser
  }
  return methods

service.$inject = [ '$rootScope', '$q', '$http', '$sessionStorage', '$state', '$location' ]

angular.module( module.name ).factory module.services.authentication, service
