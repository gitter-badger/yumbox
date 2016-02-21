module = window.sys.modules.settings

controller = ($scope, $rootScope, $state, $stateParams, $http, $sessionStorage) ->

  methods =
    assign: ->

    load: ->
      $http.get(module.endpoints.profile)
        .success (response) ->
          $scope.hostel = response.data

      $http.get(module.endpoints.api.get)
        .success (response) ->
          $scope.plugins = response.data.browser_api.settings

    events:
      assign: ->
        $scope.change_server_api = methods.events.change_server_api

      change_server_api: (key, type, done) ->
        $http.post( module.endpoints.reset.replace(':key', key), { type: type } )
          .success (response) ->
            $scope.hostel.server_api_key = response.data.doc_key
            done()
          .error (data, status) ->
            console.log data, status

  methods.assign()
  methods.load()
  methods.events.assign()

controller.$inject = module.controllers.base.inject

angular.module( module.name ).controller module.controllers.base.name, controller
