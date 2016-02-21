module = window.sys.partials.toolbar

menuController = ( $scope,
  $rootScope,
  $state,
  $stateParams,
  $http,
  authentication,
  $sessionStorage,
  hotkeys,
  focus,
  $modal) ->

    storage = $sessionStorage.$default( { currentUser: null } )

    methods =
      assign: ->
        $scope.console = { query: '', hidden: true }
        $scope.state = module.enums.normal
        $scope.hostel = storage.currentUser
        $rootScope.$on(
          sys.modules.auth.events.sessionStarted,
          -> $scope.hostel = storage.currentUser
        )

      events:
        assign: ->
          $rootScope.$on '$stateChangeSuccess', methods.events.search.check
          $scope.logout = methods.events.logout
          $scope.search = methods.events.search
          $scope.menu = methods.events.menu
          $scope.shoutout =
            show: methods.events.shoutout.show
          $scope.console.find = methods.events.console.find
          $scope.console.choose = methods.events.console.choose
          $scope.console.close = methods.events.console.close
          $scope.fullscreen =
            toggle: methods.events.fullscreen.toggle

          $rootScope.$on '$stateChangeStart', (event, next) ->
            if next.name == sys.modules.console.states.show.name
              $scope.state = module.enums.console
              console.log 'Console toolbar'
        
        shoutout:
          show: ->
            modal = $modal.open(
              animation: true
              templateUrl: 'shoutoutModal'
              controller: 'shoutoutCtrl'
            )
            modal.result.then (message) ->
              $http.post( module.endpoints.shoutout, {message: message} )
                .success (response) ->
                  $scope.shoutout.sent = true
                .error (data, status) ->
                  console.log status

        fullscreen:
          toggle: ->
            if methods.events.fullscreen.exit()
              true
            else
              methods.events.fullscreen.enter()

          exit: ->
            if document.exitFullscreen
              document.exitFullscreen()
            else if document.mozCancelFullScreen
              document.mozCancelFullScreen()
            else if document.webkitExitFullscreen
              document.webkitExitFullscreen()

          enter: ->
            element = document.documentElement

            if element.requestFullscreen
              element.requestFullscreen()
            else if element.mozRequestFullScreen
              element.mozRequestFullScreen()
            else if element.webkitRequestFullscreen
              element.webkitRequestFullscreen()
            else if element.msRequestFullscreen
              element.msRequestFullscreen()

        menu: ($event) ->
          $rootScope.sidebarToggle.left = !$rootScope.sidebarToggle.left
          $event.stopPropagation()

        logout: ->
          authentication.logout()

        console:
          close: ->
            $scope.state = module.enums.normal
            $state.go 'home'

          find: ->
            $scope.console.hidden = false
            $rootScope.$emit window.sys.modules.console.events.search, $scope.console.query

          choose: (i) ->
            $scope.console.query = $rootScope.matched_apis[i].url
            $scope.console.hidden = true
            $rootScope.$emit window.sys.modules.console.events.choose, i

        search:
          check: (ev, to, toParams, from, fromParams) ->
            methods.events.search.close() if from.name == sys.modules.search.states.show.name
            if to.name == sys.modules.search.states.show.name && to.name != from.name
              $scope.query = $stateParams.q

          find: ($event) ->
            return methods.events.search.clear($event) if $event.which == 27
            if $state.current.name == sys.modules.search.states.show.name
              $state.go 'search', { q: $scope.query }, { location: 'replace', notify: false }
              $rootScope.$broadcast sys.modules.search.events.changed
            else
              if $scope.query? and $scope.query.length > 3
                $state.go 'search', { q: $scope.query }

          open: ->
            $scope.state = module.enums.search
            $scope.readyToType = true
            focus 'search'

          clear: ($event) ->
            $('#top-search-wrap input').blur()
            methods.events.search.close()
            $event.stopPropagation()

          close: ->
            $scope.state = module.enums.normal

    methods.assign()
    methods.events.assign()

menuController.$inject = module.controllers.base.inject
angular.module( module.name ).controller module.controllers.base.name , menuController

shoutOutController = ($scope, $modalInstance) ->
  $scope.message = ''
  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'

  $scope.$watch 'message', (value, old_value) ->
    if(value.length > 160)
      $scope.message = old_value

  $scope.send = ->
    $modalInstance.close($scope.message.replace(/\n/g, ''))

shoutOutController.$inject = ['$scope', '$modalInstance']
angular.module( module.name ).controller 'shoutoutCtrl', shoutOutController
