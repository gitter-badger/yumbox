module = window.sys.modules.analytics

controller = ($scope, $stateParams, $timeout) ->
  $scope.guests = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul']
    series: [
      {
        name: 'Matchbox'
        data: [320, 307, 392, 239, 201, 198, 280]
      }
      {
        name: 'Sydney avg.'
        data: [180, 210, 399, 333, 218, 200, 167]
      }
    ]
  }
  $scope.countries = {
    labels: ['UK', 'Germany', 'Italy', 'US', 'China']
    series: [500, 300, 400, 200, 150]
  }
  $scope.bookings = {
    labels: ['Booking.com', 'Agoda', 'Hostel World', 'Booking Button', 'Expedia']
    series: [90, 220, 140, 210, 50]
  }
  $scope.activities = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
    series: [
      [190, 190, 110, 250, 150, 210]
      [210, 160, 140, 210, 120, 190]
      [230, 120, 120, 230, 210, 170]
      [220, 210, 240, 190, 180, 145]
      [120, 180, 140, 210, 280, 215]
      [210, 170, 190, 160, 230, 250]
    ]
  }

  $scope.animate = (data) ->
    if data.type == 'line' or data.type == 'area'
      data.element.animate {
        d: {
          begin: 500 * data.index
          dur: 500
          from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify()
          to: data.path.clone().stringify()
          easing: Chartist.Svg.Easing.easeOutQuint
        }
      }

  $chart = $('#guest-chart')
  $toolTip = $('#chart-tip').hide()
  $chart.on 'mouseenter', '.ct-point', ->
    $point = $(@)
    value = $point.attr('ct:value')
    seriesName = $point.parent().attr('ct:series-name')
    $toolTip.show().find('.tooltip-inner').html(seriesName + '<br>' + value)

  $chart.on 'mouseleave', '.ct-point', ->
    $toolTip.hide()

  $chart.on 'mousemove', ->
    left = (event.offsetX || event.originalEvent.layerX) + 26
    top = (event.offsetY || event.originalEvent.layerY) + 23
    $toolTip.css {
      left: left - $toolTip.width() / 2
      top: top - $toolTip.height() - 12
    }

controller.$inject = module.controllers.base.inject

angular.module( module.name ).controller module.controllers.base.name , controller
