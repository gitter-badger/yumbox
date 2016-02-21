module = window.sys.modules.settings

controller = ($scope, $rootScope, $http) ->

  methods =
    assign: ->
      $scope.current_password = null
      $scope.new_password = null

    events:
      assign: ->
        $scope.update = methods.events.update

      update: ->
        $scope.error = null
        $http.put( module.endpoints.password, { current_password: $scope.current_password, new_password: $scope.new_password } )
          .success (response) ->
            if response.data.success
              $scope.updated = true
            else
              $scope.error = "Your current password is not correct"
          .error (data, status) ->
            $scope.error = data.message.split('[')[1].slice(0, -1) if status == 400

  methods.assign()
  methods.events.assign()

controller.$inject = module.controllers.password.inject

angular.module( module.name ).controller module.controllers.password.name, controller
