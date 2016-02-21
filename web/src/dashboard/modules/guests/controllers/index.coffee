module = window.sys.modules.guests

controller = ($scope, $stateParams, guestsService, $http) ->

  methods =
    assign: ->
      $scope.guests =
        upcomings:
          list: []
          page: 0
          total: 0
        currents:
          list: []
          page: 0
          total: 0
        pasts:
          list: []
          page: 0
          total: 0

    events:
      assign: ->
        $scope.more = methods.guests.list

    load: ->
      methods.guests.list('upcomings')
      methods.guests.list('currents')
      methods.guests.list('pasts')

    guests:
      list: (type) ->
        url = "#{module.endpoints.list}?page=#{$scope.guests[type].page}&"
        url = "#{url}filter=#{type}"
        $http.get( url )
          .then (response) ->
            $scope.guests[type].page++
            $scope.guests[type].total = response.data.data.total
            $scope.guests[type].list = $scope.guests[type].list.concat response.data.data.list

  methods.assign()
  methods.events.assign()
  methods.load()

controller.$inject = module.controllers.index.inject

angular.module( module.name ).controller module.controllers.index.name , controller
