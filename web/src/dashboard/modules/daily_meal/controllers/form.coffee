module = window.sys.modules.activities

controller = ($scope, $state, $http, $timeout, FileUploader) ->

  methods =
    assign: ->
      $scope.is_edit = $state.current.name == module.states.edit.name
       
      $http.get( module.endpoints.get_main_dishes).then (response) ->
        $scope.daily_meal.main_dish = response.data
      $http.get( module.endpoints.get_side_dishes).then (response) ->
        $scope.daily_meal.side_dish = response.data
        $scope.daily_meal = {
            main_dish: ''
            side_dishes: ''
            total: ''
            at: moment()
            remained: ''
          }

    clear: ->
      jsonMask $scope.daily_meal, 'main_dish,side_dishes,total,at,remained/*,is_draft'

    events:
      assign: ->
        $scope.remove = methods.events.remove
        $scope.is_main = methods.events.is_main
        $scope.set_as_main = methods.events.set_as_main
        $scope.save = methods.events.save

      save: ->
        if $scope.is_edit
          methods.events.update()
        else
          methods.events.create()

      create: ->
        $http.post( module.endpoints.create, methods.clear($scope.daily_meal) )
          .success (response) ->
            console.log response
            $state.go 'edit_daily_meal', { id: response.data.doc_key }
          .error (data, status) ->
            console.log status
            $scope.error = data.message.split('[')[1].slice(0, -1) if status == 400

      update: ->
        url = module.endpoints.update.replace(':id', $state.params.id )
        $http.put( url, methods.clear($scope.daily_meal) )
          .success (response) ->
            $scope.daily_meal = response.data
          .error (data, status) ->
            $scope.error = data.message.split('[')[1].slice(0, -1) if status == 400

      remove: (index) ->
        url = module.endpoints.images.remove.replace(':id', $state.params.id )
          .replace(':name', $scope.daily_meal.images[index])
        $http.delete( url ).then (response) ->
          $scope.daily_meal.images.splice index, 1


        timeout_decode = null
        $scope.$watch 'daily_meal.address', ->
          $timeout.cancel timeout_decode
          timeout_decode = $timeout(
            ->
              decode()
            , 2000
          )


      is_main: (name) ->
        name.match(/main/) != null

      set_as_main: (index) ->
        url = module.endpoints.images.main.replace(':id', $state.params.id )
          .replace(':name', $scope.daily_meal.images[index])
        $http.post( url ).then (response) ->
          response.data.data = methods.fix_cache response.data.data
          $scope.daily_meal.images = response.data.data

    uploader: ->
      uploader = $scope.uploader = new FileUploader { autoUpload: true, alias: 'images[0]' }
      uploader.onSuccessItem = (fileItem, response, status, headers) ->
        response.data = methods.fix_cache response.data
        $scope.daily_meal.images = response.data

    editing: ->
      $scope.uploader.url = module.endpoints.images.add.replace(':id', $state.params.id)
      $http.get( module.endpoints.get.replace(':id', $state.params.id ) ).then (response) ->
        response.data.data.images = methods.fix_cache response.data.data.images
        $scope.daily_meal = response.data.data

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
  methods.editing() if $scope.is_edit

controller.$inject = module.controllers.form.inject

angular.module( module.name ).controller module.controllers.form.name , controller
