module = window.sys.modules.main_dishes

controller = ($scope, $stateParams, $http) ->

  methods =
    assign: ->
      $scope.main_dishes =
        list: []
        page: 0
        total: 0
        disabled: true
      $scope.more = methods.load

    load: ->
      $scope.main_dishes.disabled = true
      url = "#{module.endpoints.list}?page=#{$scope.main_dishes.page}"
      $http.get( url )
        .success (response) ->
          $scope.main_dishes.page++
          $scope.main_dishes.total = response.data.total
          for item in response.data.list
            item.cache_uid = moment().format('x')
            $scope.main_dishes.list.push item
          $scope.main_dishes.disabled = $scope.main_dishes.list.length >= response.data.total

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
