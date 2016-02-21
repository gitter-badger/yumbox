module = window.sys.modules.settings

controller = ($scope, $rootScope, $http) ->

  methods =
    assign: ->
      $scope.settings =
        guests: null
    
    load: ->
      $http.get(module.endpoints.api.get)
        .success (response) ->
          $scope.settings = response.data.browser_api.settings
          $scope.api_key = response.data.browser_api.doc_key

      jQuery('<script id="tipi-script"/>')
        .attr('src', '/plugins.js?uid=api_f6cfae02d4b6ee59c3fca2084ef5187954712e30&plugins=guests,reviews')
        .appendTo('head')

      $scope.$watchCollection 'settings.guests', ->
        try
          tipi.guests {
            demo: true
            dark: $scope.settings.guests.dark
            style: $scope.settings.guests.style
          }
        catch e

    events:
      assign: ->
        $scope.update = methods.events.update

      update: ->
        $scope.error = null
        console.log $scope.settings
        $http.put( module.endpoints.api.update.replace(':key', $scope.api_key), { settings: { guests: $scope.settings.guests } } )
          .success (response) ->
            console.log response
            if response.data.success
              $scope.updated = true
          .error (data, status) ->
            $scope.error = data.message.split('[')[1].slice(0, -1) if status == 400

  methods.assign()
  methods.load()
  methods.events.assign()

controller.$inject = module.controllers.plugins.inject

angular.module( module.name ).controller module.controllers.plugins.name, controller
