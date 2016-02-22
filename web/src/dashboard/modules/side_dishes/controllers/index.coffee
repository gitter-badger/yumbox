module = window.sys.modules.side_dishes

controller = ($scope, $stateParams, $http) ->

  methods =
    assign: ->
      $scope.side_dishes =
        list: []
        page: 0
        total: 0
        disabled: true
      $scope.more = methods.load

    load: ->
      $scope.side_dishes.disabled = true
      url = "#{module.endpoints.list}?page=#{$scope.side_dishes.page}"
      $http.get( url )
        .success (response) ->
          $scope.side_dishes.page++
          $scope.side_dishes.total = response.data.total
          for item in response.data.list
            item.cache_uid = moment().format('x')
            $scope.side_dishes.list.push item
          $scope.side_dishes.disabled = $scope.side_dishes.list.length >= response.data.total

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
