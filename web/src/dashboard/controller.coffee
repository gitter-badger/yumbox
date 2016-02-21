module = sys.modules.app

controller = ($scope, $rootScope, $state, hotkeys, $modal, $http, $sessionStorage) ->

  methods =
    assign: ->
      $rootScope.sidebarToggle =
        left: false
        right: false

      $rootScope.$on module.events.walkthrough.skipped, methods.walkthrough

    walkthrough: (event, message) ->
      $sessionStorage.currentUser.settings.walkthrough[message.name] = message.status
      $http.put( module.endpoints.walkthrough, message )

    events:
      assign: -> true

    hotkeys: ->
      hotkeys.add {
        combo: '?'
        description: 'Show/hide this help'
        callback: ->
          $scope.hotkeys = hotkeys.get()
          $modal.open {
            animation: true
            scope: $scope
            templateUrl: 'hotkeys.html'
            size: 'lg'
          }
      }

  methods.assign()
  methods.events.assign()
  methods.hotkeys()

controller.$inject = module.controllers.base.inject

angular.module( module.name ).controller module.controllers.base.name, controller
