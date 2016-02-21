module = window.sys.modules.activities

controller = ($scope, $stateParams, $http) ->

  methods =
    assign: ->
      $scope.activities =
        list: []
        page: 0
        total: 0
        disabled: true
      $scope.more = methods.load

    load: ->
      $scope.activities.disabled = true
      url = "#{module.endpoints.list}?page=#{$scope.activities.page}"
      $http.get( url )
        .success (response) ->
          $scope.activities.page++
          $scope.activities.total = response.data.total
          for item in response.data.list
            item.cache_uid = moment().format('x')
            $scope.activities.list.push item
          $scope.activities.disabled = $scope.activities.list.length >= response.data.total

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
