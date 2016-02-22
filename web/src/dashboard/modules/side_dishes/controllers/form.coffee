module = window.sys.modules.side_dishes

controller = ($scope, $state, $http, $timeout, FileUploader) ->

  methods =
    assign: ->
      $scope.is_edit = $state.current.name == module.states.edit.name
      $scope.interests = sys.defaults.interests
      $scope.side_dish = {
        title: ''
        address: ''
        description: ''
        images: []
        at: moment()
        interests: []
        price: ''
      }

    clear: ->
      jsonMask $scope.side_dish, 'title,description,at/*,interests,price,is_draft'

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
        $http.post( module.endpoints.create, methods.clear($scope.side_dish) )
          .success (response) ->
            console.log response
            $state.go 'edit_side_dish', { id: response.data.doc_key }
          .error (data, status) ->
            console.log status
            $scope.error = data.message.split('[')[1].slice(0, -1) if status == 400

      update: ->
        url = module.endpoints.update.replace(':id', $state.params.id )
        $http.put( url, methods.clear($scope.side_dish) )
          .success (response) ->
            $scope.side_dish = response.data
          .error (data, status) ->
            $scope.error = data.message.split('[')[1].slice(0, -1) if status == 400

      remove: (index) ->
        url = module.endpoints.images.remove.replace(':id', $state.params.id )
          .replace(':name', $scope.side_dish.images[index])
        $http.delete( url ).then (response) ->
          $scope.side_dish.images.splice index, 1


      is_main: (name) ->
        name.match(/main/) != null

      set_as_main: (index) ->
        url = module.endpoints.images.main.replace(':id', $state.params.id )
          .replace(':name', $scope.side_dish.images[index])
        $http.post( url ).then (response) ->
          response.data.data = methods.fix_cache response.data.data
          $scope.side_dish.images = response.data.data

    uploader: ->
      uploader = $scope.uploader = new FileUploader { autoUpload: true, alias: 'images[0]' }
      uploader.onSuccessItem = (fileItem, response, status, headers) ->
        response.data = methods.fix_cache response.data
        $scope.side_dish.images = response.data

    editing: ->
      $scope.uploader.url = module.endpoints.images.add.replace(':id', $state.params.id)
      $http.get( module.endpoints.get.replace(':id', $state.params.id ) ).then (response) ->
        response.data.data.images = methods.fix_cache response.data.data.images
        $scope.side_dish = response.data.data

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
