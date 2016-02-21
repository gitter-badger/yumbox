module = window.sys.modules.search

controller = ($scope, $rootScope, $state, $stateParams, $http, $sessionStorage) ->

  methods =
    assign: ->
      $scope.constants = module.constants
      $scope.results = {}
      $scope.noSearch = true

      $scope.guests =
        list: [
          {
            user: {
              name: 'Emilia Brekke'
              city: 'Sydney'
              country: 'Australia'
              age: 24
              gender: 1
            }
            doc_key: 'g_41GxXbN3u6'
            user_key: 'u_41WpUaVBn'
            email: 'amanda@gmail.com'
            from: '2015-09-09T10:04:26+04:30'
            to: '2015-09-19T10:04:26+04:30'
          }
        ]
        total: 5

      $scope.bookings = $scope.guests

    load: -> true

    events:
      assign: ->
        methods.search.find()
        $scope.search = { scope: methods.search.scope }
        $scope.$on sys.modules.search.events.changed, methods.search.find

    search:
      last_term: null

      scope: (scope) ->
        $state.go 'search', { q: $scope.query, s: scope }, { location: 'replace', notify: false }
        $rootScope.$broadcast sys.modules.search.events.changed

      clear: ->
        $scope.results = {}
        $scope.noSearch = true

      find: ->
        return if angular.equals methods.search.last_term, $stateParams
        methods.search.last_term = angular.copy $stateParams
        $scope.query = $stateParams.q
        $scope.scope = $stateParams.s
        return methods.search.clear() if !$scope.query? or $scope.query.length < 3
        $scope.noSearch = false
        url = "#{module.endpoints.search}?q=#{$scope.query}"
        url = "#{url}&s=#{$scope.scope}" if $scope.scope?
        console.log url
        $http.get( url )
          .success (response) ->
            $scope.results = response.data
            console.log $scope.results

  methods.assign()
  methods.load()
  methods.events.assign()

controller.$inject = module.controllers.base.inject

angular.module( module.name ).controller module.controllers.base.name, controller
