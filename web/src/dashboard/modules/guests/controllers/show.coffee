module = window.sys.modules.guests

controller = ($scope, $stateParams, guestsService, $http) ->
  $scope.guest_key = $stateParams.id
  $scope.user_key = $stateParams.user_key
  $scope.reviews = module.constants.reviews
  $scope.interests = sys.defaults.interests

  $scope.guest = guestsService.getGuest $scope.guest_key

  $http.get( module.endpoints.get.replace(':id', $scope.guest_key), cache: false ).then (response) ->
    $scope.guest = response.data.data
    $http.get( module.endpoints.activities.suggest.replace(':id', $scope.guest.user_key) )
      .then (response) ->
        $scope.activities = response.data.data

  $scope.passport_confirmation = (status) ->
    data =
      confirmed: (status == $scope.reviews.approved)
    $http.put( module.endpoints.passport.replace(':id', $scope.guest.user_key), data )
      .then (response) ->
        $scope.guest.user.passport.review.status = status if response.data.data.success

  $scope.checkin = ->
    $http.post( module.endpoints.checkin.replace(':id', $scope.guest.doc_key) ).then (response) ->
      $scope.guest.checkedin_at = new Date

  $scope.checkout = ->
    $http.post( module.endpoints.checkout.replace(':id', $scope.guest.doc_key) ).then (response) ->
      $scope.guest.checkedout_at = new Date

  $scope.attend = (activity) ->
    data = { user_key: $scope.guest.user_key }
    $http.post( module.endpoints.activities.attend.replace(':id', activity.doc_key), data )
      .then (response) ->
        activity.has_attended = true

  $scope.passport_review =
    correct_number: false
    correct_image: false

controller.$inject = module.controllers.show.inject

angular.module( module.name ).controller module.controllers.show.name , controller
