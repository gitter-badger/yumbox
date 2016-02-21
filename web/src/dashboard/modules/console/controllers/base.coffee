module = window.sys.modules.console

controller = ($scope, $rootScope, $state, $stateParams, $http) ->

  methods =
    assign: ->
      $rootScope.logged_in = true
      $scope.request = {}
      $scope.response = {}
      $rootScope.matched_apis = []
      $scope.apis = [
        {
          method: 'get'
          url: 'GET /v1/pms/bookings'
          description: 'List all bookings'
          summary: 'Not available yet.'
          type: 'get_bookings'
          enabled: false
        }
        {
          method: 'post'
          url: 'POST /v1/pms/bookings'
          description: 'Create or update a booking'
          summary: "Should be called at reservation, it's updates and check-in / out time."
          type: 'post_bookings'
          enabled: true
        }
        {
          method: 'get'
          url: 'GET /v1/pms/bookings/:id'
          description: 'Get an existing booking'
          summary: 'Not available yet.'
          type: 'get_bookings'
          enabled: false
        }
      ]

    submit: ->
      if $scope.current.method == 'post'
        $http(
          method: $scope.current.method
          headers:
            'api-key': $stateParams.key
          url: "/api#{$scope.current.url.split(' ')[1]}"
          data: $scope.request
        ).success( (doc) ->
          $scope.response = doc
        ).error (doc) ->
          $scope.response = doc

    events:
      assign: ->
        $rootScope.$on module.events.search, methods.console.find
        $rootScope.$on module.events.choose, methods.console.choose
        $scope.submit = methods.submit

    console:
      choose: ($event, i) ->
        $scope.current = $rootScope.matched_apis[i]
        $scope.request = {}
        $scope.response = {}

      find: ($event, q) ->
        $rootScope.matched_apis = []
        return if q == ''
        $.each $scope.apis, (i, api) ->
          if api.url.match(new RegExp(q, 'i'))
            $rootScope.matched_apis.push api

  methods.assign()
  methods.events.assign()

controller.$inject = module.controllers.base.inject

angular.module( module.name ).controller module.controllers.base.name, controller

