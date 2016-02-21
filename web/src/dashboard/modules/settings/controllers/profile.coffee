module = window.sys.modules.settings

controller = ($scope, $rootScope, $http, $timeout, FileUploader) ->

  methods =
    assign: ->
      $scope.hostel = {}
      $scope.countries =
        'Australia': 'Australia'
        'New Zealand': 'New Zealand'
        'United Kingdom': 'United Kingdom'
      $scope.cities =
        'Sydney': 'Sydney'
        'Melbourne': 'Melbourne'

    load: ->
      $http.get(module.endpoints.profile)
        .success (response) ->
          $scope.hostel = response.data
          $scope.avatar = "/cdn/hostel/#{$scope.hostel.doc_key}/mavatar.jpg"

    clear: ->
      jsonMask $scope.hostel, 'name,address,description,location/*,interests,country,city,phone,reception_name'

    events:
      assign: ->
        $scope.remove = methods.events.remove
        $scope.$on 'mapInitialized', methods.events.map
        $scope.is_main = methods.events.is_main
        $scope.set_as_main = methods.events.set_as_main
        $scope.update = methods.events.update

      update: ->
        $http.put( module.endpoints.profile, methods.clear($scope.hostel) )
          .success (response) ->
            console.log response
            $scope.hostel = response.data
          .error (data, status) ->
            $scope.error = data.message.split('[')[1].slice(0, -1) if status == 400

      remove: (index) ->
        $http.delete( module.endpoints.images.remove.replace(':name', $scope.hostel.images[index]) ).then (response) ->
          $scope.hostel.images.splice index, 1

      map: (evt, evtMap) ->
        map = evtMap

        decode = ->
          geocoder = new google.maps.Geocoder()
          geocoder.geocode { address: $scope.hostel.address }, (results, status) ->
            if status == google.maps.GeocoderStatus.OK
              location = results[0].geometry.location
              map.setCenter location
              map.markers[0].setPosition location
              map.panTo location
              $scope.hostel.location =
                latitude: location.lat()
                longitude: location.lng()

        timeout_decode = null
        $scope.$watch 'hostel.address', ->
          $timeout.cancel timeout_decode
          timeout_decode = $timeout(
            ->
              decode()
            , 2000
          )

        $scope.mark = (e) ->
          $scope.hostel.location =
            latitude: e.latLng.lat()
            longitude: e.latLng.lng()
          map.panTo e.latLng

      is_main: (name) ->
        name.match(/main/) != null

      set_as_main: (index) ->
        $http.post( module.endpoints.images.main.replace(':name', $scope.hostel.images[index]) ).then (response) ->
          response.data.data = methods.fix_cache response.data.data
          $scope.hostel.images = response.data.data

    uploader: ->
      uploader = $scope.uploader = new FileUploader { autoUpload: true, alias: 'images[0]', url: module.endpoints.images.add }
      uploader.onSuccessItem = (fileItem, response, status, headers) ->
        response.data = methods.fix_cache response.data
        $scope.hostel.images = response.data

      avatar_uploader = $scope.avatar_uploader = new FileUploader { autoUpload: true, alias: 'avatar', url: module.endpoints.avatar }
      avatar_uploader.onSuccessItem = (fileItem, response, status, headers) ->
        $scope.avatar = "#{$scope.avatar}?#{moment()}"

    fix_cache: (images) ->
      return [] unless images?
      for image, i in images
        if /main/.test image
          images[i] = "#{image}?#{moment()}"
          return images
      images


  methods.assign()
  methods.events.assign()
  methods.uploader()
  methods.load()

controller.$inject = module.controllers.profile.inject

angular.module( module.name ).controller module.controllers.profile.name, controller
