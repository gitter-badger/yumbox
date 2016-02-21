module = window.sys.partials.sidebar

menuController = ($scope, $rootScope, $state, authentication, $sessionStorage) ->

  storage = $sessionStorage.$default( { currentUser: null } )

  methods =
    assign: ->
      sidebarToggle = { left: false }
      $scope.hostel = storage.currentUser
      $rootScope.$on sys.modules.auth.events.sessionStarted, -> $scope.hostel = storage.currentUser
      $rootScope.$on sys.modules.auth.events.loggedOut, methods.menu.hide

    events:
      assign: ->
        $scope.logout = methods.events.logout
        $scope.hide = methods.menu.hide

      logout: ->
        authentication.logout()

    menu:
      init: ->
        $('#sidebar').click ($event) ->
          $event.stopPropagation()
        $(window).click ->
          methods.menu.hide()
          $rootScope.$apply()

      hide: ->
        $rootScope.sidebarToggle.left = false

  methods.assign()
  methods.events.assign()
  methods.menu.init()

menuController.$inject = module.controllers.base.inject
angular.module( module.name ).controller module.controllers.base.name , menuController
