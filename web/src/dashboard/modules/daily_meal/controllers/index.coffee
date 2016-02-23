module = window.sys.modules.daily_meal

controller = ($scope, $stateParams, $http) ->

  methods =
    assign: ->
      $scope.daily_meal =
        list: []
        page: 0
        total: 0
        disabled: true
      $scope.more = methods.load

    load: ->
      $scope.daily_meal.disabled = true
      url = "#{module.endpoints.list}?page=#{$scope.daily_meal.page}"
      $http.get( url )
        .success (response) ->
          $scope.daily_meal.page++
          $scope.daily_meal.total = response.data.total
          for item in response.data.list
            item.cache_uid = moment().format('x')
            $scope.daily_meal.list.push item
          $scope.daily_meal.disabled = $scope.daily_meal.list.length >= response.data.total

    fix_cache: (images) ->
      for image, i in images
        if /main/.test image
          images[i] = "#{image}?#{moment()}"
          return images
      images

  methods.assign()
  methods.load()

controller.$inject = module.controllers.index.inject

angular.module( module.name ).controller module.controllers.index.name , controller
