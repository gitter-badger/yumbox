app = angular.module sys.modules.app.name

app.directive 'snackbar', ->
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      notify = (from, align, icon, type, animIn, animOut) ->
        $.growl(
          {
            icon: icon
            title: $(element).data('title')
            message: $(element).data('message')
            url: ''
          },
          {
            element: 'body'
            type: type
            allow_dismiss: true
            placement:
              from: from
              align: align
            offset:
              x: 20
              y: 85
            spacing: 10
            z_index: 1031
            delay: 2500
            timer: 1500
            url_target: '_blank'
            mouse_over: false
            animate:
              enter: animIn
              exit: animOut
            icon_type: 'class'
            onHide: -> true
            template: '<div data-growl="container" class="alert" role="alert">' +
              '<button type="button" class="close" data-growl="dismiss">' +
                '<span aria-hidden="true">&times;</span>' +
                '<span class="sr-only">Close</span>' +
              '</button>' +
              '<span data-growl="icon"></span>' +
              '<span data-growl="title"></span>' +
              '<span data-growl="message"></span>' +
              '<a href="#" data-growl="url"></a>' +
            '</div>'
          }
        )
      scope.$watch attrs.snackbarShow, (value) ->
        if eval(value)
          nFrom = attrs.from
          nAlign = attrs.align
          nIcons = attrs.icon
          nType = attrs.type
          nAnimIn = attrs.animationIn
          nAnimOut = attrs.animationOut
          notify nFrom, nAlign, nIcons, nType, nAnimIn, nAnimOut
          scope.$eval("#{attrs.snackbarShow}=false")
  }


app.directive 'qrcode', ->
  {
    restrict: 'E',
    link: (scope, element, attrs) ->
      element.started = false
      scope.$watch attrs.scanning, (value) ->
        if value
          success = (data) ->
            scope.$eval(attrs.success) data if attrs.success?
            scope.$apply()
          error = (error) ->
            scope.$eval(attrs.error) error if attrs.error?
            scope.$apply()
          debug = (error) ->
            scope.$eval(attrs.debug) error if attrs.debug?
            scope.$apply()
          $(element).html5_qrcode success, debug, error unless element.started
          element.started = true
        else
          return unless element.started
          try
            $(element).html5_qrcode_stop()
            $(element).empty()
            element.started = false
          catch ex
            scope.error "Can't start camera"
  }


app.directive 'bgImage', ->
  {
    link: (scope, element, attrs) ->
      attrs.$observe 'bgImage', ->
        if attrs.bgImage
          image = new Image()
          src = if attrs.bgImagePath
            attrs.bgImagePath.replace ':image', attrs.bgImage
          else
            attrs.bgImage
          image.src = src
          image.onload = -> element.css 'background-image', "url('" + src + "')"
  }

app.directive 'errSrc', ->
  {
    link: (scope, element, attrs) ->
      element.bind 'error', ->
        if attrs.src != attrs.errSrc
          attrs.$set 'src', attrs.errSrc
  }

app.directive 'percent', ->
  {
    link: (scope, element, attrs) ->
      attrs.$observe 'percent', ->
        $(element).data('easyPieChart').update(attrs.percent) if $(element).data('easyPieChart')?
  }

app.directive 'btn', ->
  {
    restrict: 'C',
    link: (scope, element) ->
      Waves.attach(element)
      Waves.init()
  }

app.directive 'btnWave', ->
  {
    restrict: 'C',
    link: (scope, element) ->
      Waves.attach(element)
      Waves.init()
  }

app.directive 'swalConfirm', [ '$parse', ($parse)->
  {
    restrict: 'A'
    scope : true
    link: (scope, element, attrs) ->
      element.click ->
        swal {
          title: attrs.title || "Are you sure?"
          text: attrs.message || "You will not be able to recover this imaginary file!"
          type: attrs.type || "warning"
          showCancelButton: true
          confirmButtonColor: attrs.confirmColor || "#DD6B55"
          confirmButtonText: attrs.confirmButton || "Yes, delete it!"
          closeOnConfirm: !attrs.confirm?
        }, ->
          if attrs.confirm?
            fn = $parse attrs.confirm
            fn scope, {
              done: -> swal attrs.successTitle, attrs.successMessage, 'success'
            }
  }
]
