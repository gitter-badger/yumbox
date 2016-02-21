module = sys.modules.auth

loginController = ($scope, $rootScope, $state, authentication, home, $localStorage, $http) ->

  methods =
    assign: ->
      $rootScope.logged_in = false
      $scope.storage = $localStorage
      $scope.state = $state.current.currentTab
      $scope.isBusy = false
      $scope.failed = false
      $scope.user = { email: '', password: '' }

    retrieveAccount: ->
      return unless $localStorage.account
      $scope.user.email = $localStorage.account.email

    events:
      assign: ->
        $scope.login = methods.events.login
        $scope.signup = methods.events.signup
        $scope.clear = methods.events.clear

      clear: ->
        $localStorage.account = null

      login: ->
        $scope.failed = false
        if ! $scope.isBusy
          $scope.isBusy = true
          authentication.login($scope.user.email, $scope.user.password).then(
            (currentUser) ->
              methods.events.logged currentUser.doc_key
            , (error) ->
              $scope.error = error
              $scope.failed = true
          )['finally'](
            -> $scope.isBusy = false
          )

      logged: (user_key) ->
        $localStorage.account = { email: $scope.user.email, doc_key: user_key }
        $rootScope.logged_in = true
        $state.go home.homeState

      signup: ->
        if $scope.user.email == '' or $scope.user.name == '' or $scope.user.password == ''
          return $scope.terms_failed = 'Please fill all fields.'
        return $scope.terms_failed = 'Please accept the terms first.' unless $scope.terms_accepted
        $scope.terms_failed = ''
        data = { name: $scope.user.name, email: $scope.user.email, password: $scope.user.password }
        $http.post( module.endpoints.signup, data )
          .success (response) ->
            authentication.logged response.data
            methods.events.logged response.data.doc_key
          .error (data, status) ->
            return $scope.terms_failed = data.message.split('[')[1].split(']')[0] if data.message?
            console.log data, status
            $scope.terms_failed = 'This email is already registered.'

  methods.assign()
  methods.retrieveAccount()
  methods.events.assign()

loginController.$inject = module.controllers.base.inject

angular.module( module.name ).controller module.controllers.base.name , loginController
