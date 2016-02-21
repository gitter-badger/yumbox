module = window.sys.modules.bookings

controller = ($scope, $stateParams, $http) ->

  methods =
    assign: ->
      $scope.search =
        from: null
        to: null
        name: null

      $scope.bookings =
        list: []
        page: 0

    events:
      assign: ->
        $scope.more = methods.list

    load: ->
      methods.list()

    list: (type) ->

      url = "#{module.endpoints.list}?page=#{$scope.bookings.page}"
      console.log url
      $http.get( url )
        .then (response) ->
          $scope.bookings.page++
          $scope.bookings.total = response.data.data.total
          $scope.bookings.list = $scope.bookings.list.concat response.data.data.list

  methods.assign()
  methods.events.assign()
  methods.load()

controller.$inject = module.controllers.index.inject

angular.module( module.name ).controller module.controllers.index.name , controller
