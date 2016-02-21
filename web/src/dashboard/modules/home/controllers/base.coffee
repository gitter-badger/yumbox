module = window.sys.modules.home

controller = (
  $scope,
  $rootScope,
  $state,
  $stateParams,
  $http,
  $cacheFactory,
  guestsService,
  socket,
  $sessionStorage,
  $timeout ) ->

  methods =
    assign: ->
      $scope.skipped_walkthroughs =
        pms: false

      $scope.currentUser = $sessionStorage.currentUser
      $scope.pmses = window.sys.defaults.pmses
      $scope.views = module.constants.views
      $scope.views.analytics.state = $scope.views.states.loaded
      $scope.views.feed.state = $scope.views.states.loaded

      $scope.camera =
        working: true
        snackbar: false
        scanning: false

      $scope.bookings = []
      $scope.guests =
        checkins: { list: [], total: 0 }
        checkouts: { list: [], total: 0 }
      $scope.reviews =
        list: []
        total: 0
      $scope.analytics =
        guests:
          count: 0
        activities:
          views: 0
          attendees: 0

    walk: ->
      $scope.introOptions =
        steps: [
          {
            element: $('#menu-icon')[0]
            intro: '<h4>Menu</h4><p>Main menu to navigate to other pages such as activities, analytics, settings and more</p>'
            position: 'right'
          }
          {
            element: $('#search-btn')[0]
            intro: '<h4>Search</h4><p>You can search system wide for almost anything you want</p>'
            position: 'left'
          }
          {
            element: $('#guests')[0]
            intro: '<h4>Check-in/out</h4><p>Check-in/out your guests easily. Know your guests better by reviewing their profile and suggest relevant events to them.</p>'
            position: 'right'
          }
          {
            element: $('#new-activity-btn')[0]
            intro: '<h4>Activity</h4><p>Create activities and events. Your guests will be informed automatically.</p>'
            position: 'left'
          }
          {
            element: $('#reviews')[0]
            intro: '<h4>Reviews</h4><p>You can see latest reviews from your guests here. You can easily publish these reviews on your website using review add-on.</p>'
            position: 'top'
          }
          {
            element: $('#bookings')[0]
            intro: '<h4>Claimed Bookings</h4><p>As soon as someone claim a booking in your hostel, you will see a notification poping up here.</p>'
            position: 'top'
          }
          {
            element: $('#analytics')[0]
            intro: '<h4>Analytics</h4><p>Monitor your hostel performance in a snapshot here or check the detailed analytics in <a>Analytics</a> page.</p>'
            position: 'left'
          }
        ]
        nextLabel: 'Next'
        prevLabel: 'Previous'
        skipLabel: 'Skip'
        doneLabel: 'Thanks'
        exitOnOverlayClick: false
        showStepNumbers: false
        showBullets: false
        showProgress: true
        disableInteraction: true

      $scope.$apply()
      $scope.intro() unless $scope.currentUser.settings.walkthrough.first_time

    load: ->
      $http.get(module.endpoints.checkins, { cache: false })
        .success (response) ->
          $scope.views.guests.state = $scope.views.states.loaded
          $scope.guests.checkins = response.data
          guestsService.setCheckins $scope.guests.checkins.list
        .error (data, status) ->
          $scope.views.guests.state = $scope.views.states.no_access if status == 401

      $http.get(module.endpoints.checkouts, { cache: false })
        .success (response) ->
          $scope.views.guests.state = $scope.views.states.loaded
          $scope.guests.checkouts = response.data
          guestsService.setCheckouts $scope.guests.checkouts.list
        .error (data, status) ->
          $scope.views.guests.state = $scope.views.states.no_access if status == 401

      $http.get(module.endpoints.activities, { cache: false })
        .success (response) ->
          $scope.views.activities.state = $scope.views.states.loaded
          $scope.activities = response.data
        .error (data, status) ->
          $scope.views.activities.state = $scope.views.states.no_access if status == 401

      $http.get(module.endpoints.reviews.list)
        .success (response) ->
          $scope.views.reviews.state = $scope.views.states.loaded
          $scope.reviews = response.data
        .error (data, status) ->
          $scope.views.reviews.state = $scope.views.states.no_access if status == 401

      $http.get(module.endpoints.analytics.guests.count)
        .success (response) ->
          $scope.analytics.guests.count = response.data

    events:
      assign: ->
        $scope.accept_booking = methods.events.bookings.accept
        $scope.reject_booking = methods.events.bookings.reject
        $scope.success = methods.events.success
        $scope.error = methods.events.error
        $scope.scanner = methods.events.scanner
        $scope.skip = methods.events.skip
        $scope.introSkipped = methods.events.intro.done
        $scope.introDone = methods.events.intro.done
        $scope.seen = methods.events.seen

      seen: (doc_key, index) ->
        $http.post(module.endpoints.reviews.seen.replace(':id', doc_key))
          .then (response) ->
            $scope.reviews.list.splice index, 1
            $scope.reviews.total--

      intro:
        done: ->
          $rootScope.$broadcast window.sys.modules.app.events.walkthrough.skipped, { name: 'first_time', status: true }

      skip: (name, status) ->
        $scope.skipped_walkthroughs.pms = true
        $rootScope.$broadcast window.sys.modules.app.events.walkthrough.skipped, { name: name, status: status }

      success: (data) ->
        console.log 'scaned!!!!', data
        $scope.camera.scanning = false
        $scope.camera.message = "scanned #{data}"
        $scope.camera.snackbar = true
        $http.get( module.endpoints.guests.by_user.replace(':id', data) )
          .success (response) ->
            $state.go 'guest' , { id: response.data.doc_key, user_key: data }

      error: (error) ->
        $scope.camera.working = false
        $scope.camera.message = 'is disabled! Reload the page'
        $scope.camera.snackbar = true

      scanner:
        shoot: ->
          $scope.camera.scanning = !$scope.camera.scanning

      bookings:
        accept: (booking, index) ->
          $http.post(module.endpoints.guests.accept.replace(':id', booking.doc_key))
            .then (response) ->
              $scope.bookings.splice index, 1

        reject: (booking, index) ->
          $http.post(module.endpoints.guests.reject.replace(':id', booking.doc_key))
            .then (response) ->
              $scope.bookings.splice index, 1

    socket: ->
      socket.on 'error', (response) -> $scope.views.bookings.state = $scope.views.states.no_access
      socket.emit 'get_pending_guests', (response) ->
        $scope.views.bookings.state = $scope.views.states.loaded
        $scope.bookings = response.data
      socket.on 'new_pending_guest', (response) ->
        response.is_new = true
        $scope.bookings.push response
      socket.on 'new_checkin', (response) ->
        $scope.guests.checkins.list.unshift response
        $scope.guests.checkins.total += 1

    charts: ->
      easyPieChart = (id, trackColor, scaleColor, barColor, lineWidth, lineCap, size) ->
        $('.' + id).easyPieChart {
          trackColor: trackColor
          scaleColor: scaleColor
          barColor: barColor
          lineWidth: lineWidth
          lineCap: lineCap
          size: size
        }

      sparklineLine = (id, values, width, height, lineColor, fillColor, lineWidth, maxSpotColor, minSpotColor, spotColor, spotRadius, hSpotColor, hLineColor) ->
        $('.' + id).sparkline(values, {
            type: 'line',
            width: width,
            height: height,
            lineColor: lineColor,
            fillColor: fillColor,
            lineWidth: lineWidth,
            maxSpotColor: maxSpotColor,
            minSpotColor: minSpotColor,
            spotColor: spotColor,
            spotRadius: spotRadius,
            highlightSpotColor: hSpotColor,
            highlightLineColor: hLineColor
        })

      #sparklineLine('stats-line-2', [5, 6, 3, 9, 7, 5, 4, 6, 5, 6, 4, 9], 85, 45, '#fff', 'rgba(0,0,0,0)', 1.25, 'rgba(255,255,255,0.4)', 'rgba(255,255,255,0.4)', 'rgba(255,255,255,0.4)', 3, '#fff', 'rgba(255,255,255,0.4)')

      $http.get(module.endpoints.analytics.activities.overal)
        .success (response) ->
          $scope.analytics.activities = response.data
          easyPieChart('main-pie', 'rgba(255,255,255,0.2)', 'rgba(255,255,255,0.5)', 'rgba(255,255,255,0.7)', 7, 'butt', 148)
          easyPieChart('sub-pie-1', '#eee', '#ccc', '#2196F3', 4, 'butt', 95)
          easyPieChart('sub-pie-2', '#eee', '#ccc', '#FFC107', 4, 'butt', 95)

      $http.get(module.endpoints.analytics.guests.overal)
        .success (response) ->
          $scope.analytics.guests.list = response.data
          basic = []
          $.each $scope.analytics.guests.list, (index, item) ->
            basic.push item.checkins_count
          sparklineLine('guests-stats-line', basic, 85, 45, '#fff', 'rgba(0,0,0,0)', 1.25, 'rgba(255,255,255,0.4)', 'rgba(255,255,255,0.4)', 'rgba(255,255,255,0.4)', 3, '#fff', 'rgba(255,255,255,0.4)')


  methods.assign()
  methods.load()
  methods.events.assign()
  methods.socket()
  methods.charts()
  $timeout methods.walk, 1000

controller.$inject = module.controllers.base.inject

angular.module( module.name ).controller module.controllers.base.name, controller
