_ = require 'lodash'

core =
  js: [
    # Angular Core + Dependencies
    '/bower/jquery/dist/jquery.min.js'
    '/bower/angular/angular.min.js'
    '/bower/bootstrap/dist/js/bootstrap.min.js'
    '/bower/angular-bootstrap/ui-bootstrap-tpls.min.js'
  ]

app =
  js: [
    '/assets/app/js/join.js'
  ]

dashboard =
  js: [
    # Angular Core + Dependencies

    '/bower/angular-cache/dist/angular-cache.min.js'
    '/bower/angular-animate/angular-animate.min.js'

    '/bower/angular-ui-router/release/angular-ui-router.min.js'
    '/bower/angular-loading-bar/build/loading-bar.min.js'
    '/bower/oclazyload/dist/ocLazyLoad.min.js'

    '/bower/json-mask/build/jsonMask.min.js'
    '/bower/angular-hotkeys/build/hotkeys.min.js'
    '/bower/ng-focus-on/ng-focus-on.min.js'

    '/assets/vendors/vendors/nicescroll/jquery.nicescroll.min.js'
    '/assets/vendors/vendors/waves/waves.min.js'
    '/assets/vendors/vendors/bootstrap-growl/bootstrap-growl.min.js'
    '/bower/bootstrap-sweetalert/lib/sweet-alert.min.js'
    '/assets/js/libs/angular-bootstrap-select.js'
    '/assets/js/libs/ng-infinite-scroll.min.js'
    '/assets/js/libs/jsqrcode-combined.min.js'
    '/assets/js/libs/html5-qrcode.min.js'
    '/bower/ng-prettyjson/dist/ng-prettyjson.min.js'

    # Time & Dates
    '/bower/moment/min/moment.min.js'
    '/bower/angular-moment/angular-moment.min.js'

    # Forms
    '/assets/vendors/vendors/auto-size/jquery.autosize.min.js'
    '/bower/angular-file-upload/angular-file-upload.min.js'
    '/bower/angular-bootstrap-datetimepicker/src/js/datetimepicker.js'
    '/bower/ngstorage/ngStorage.min.js'
    '/bower/angular-file-upload/angular-file-upload.min.js'

    # Walkthrough
    '/bower/intro.js/minified/intro.min.js'
    '/bower/angular-intro.js/build/angular-intro.min.js'

    # Analytics
    '/bower/angulartics/dist/angulartics.min.js'
    '/bower/angulartics/dist/angulartics-ga.min.js'

    # Charts
    '/assets/vendors/vendors/easypiechart/jquery.easypiechart.min.js'
    '/assets/vendors/vendors/sparklines/jquery.sparkline.min.js'
    '/bower/chartist/dist/chartist.min.js'
    '/bower/angular-chartist.js/dist/angular-chartist.min.js'

    # Socket
    '/assets/js/libs/socket.io.min.js'
    '/bower/angular-socket-io/socket.min.js'

    # Clipboard
    '/bower/zeroclipboard/dist/ZeroClipboard.min.js'
    '/bower/ng-clip/dest/ng-clip.min.js'

    # Map
    '//maps.google.com/maps/api/js'
    '/bower/ngmap/build/scripts/ng-map.min.js'

    # Project files
    '/assets/defaults.js'
    '/assets/dashboard/js/init.js'
    '/assets/dashboard/js/modules/guests/init.js'
    '/assets/dashboard/js/modules/bookings/init.js'
    '/assets/dashboard/js/modules/activities/init.js'
    '/assets/dashboard/js/modules/main_dishes/init.js'
    '/assets/dashboard/js/modules/side_dishes/init.js'
    '/assets/dashboard/js/modules/settings/init.js'
    '/assets/dashboard/js/modules/search/init.js'
    '/assets/dashboard/js/modules/console/init.js'
    '/assets/dashboard/js/modules/home/init.js'
    '/assets/dashboard/js/modules/guests/services/guests.js'
    '/assets/dashboard/js/modules/home/controllers/base.js'
    '/assets/dashboard/js/modules/home/services/base.js'
    '/assets/dashboard/js/modules/guests/controllers/show.js'
    '/assets/dashboard/js/modules/guests/controllers/index.js'
    '/assets/dashboard/js/modules/guests/routes.js'
    '/assets/dashboard/js/modules/bookings/controllers/index.js'
    '/assets/dashboard/js/modules/bookings/routes.js'
    '/assets/dashboard/js/modules/settings/controllers/base.js'
    '/assets/dashboard/js/modules/settings/controllers/profile.js'
    '/assets/dashboard/js/modules/settings/controllers/password.js'
    '/assets/dashboard/js/modules/settings/controllers/plugins.js'
    '/assets/dashboard/js/modules/settings/routes.js'
    '/assets/dashboard/js/modules/search/controllers/base.js'
    '/assets/dashboard/js/modules/search/routes.js'
    '/assets/dashboard/js/modules/activities/controllers/index.js'
    '/assets/dashboard/js/modules/activities/controllers/form.js'
    '/assets/dashboard/js/modules/activities/routes.js'
    '/assets/dashboard/js/modules/main_dishes/controllers/index.js'
    '/assets/dashboard/js/modules/main_dishes/controllers/form.js'
    '/assets/dashboard/js/modules/main_dishes/routes.js'
    '/assets/dashboard/js/modules/side_dishes/controllers/index.js'
    '/assets/dashboard/js/modules/side_dishes/controllers/form.js'
    '/assets/dashboard/js/modules/side_dishes/routes.js'
    '/assets/dashboard/js/modules/analytics/init.js'
    '/assets/dashboard/js/modules/analytics/controllers/base.js'
    '/assets/dashboard/js/modules/analytics/routes.js'
    '/assets/dashboard/js/modules/console/controllers/base.js'
    '/assets/dashboard/js/modules/console/routes.js'
    '/assets/dashboard/js/modules/auth/init.js'
    '/assets/dashboard/js/modules/auth/routes.js'
    '/assets/dashboard/js/modules/auth/services/authentication.js'
    '/assets/dashboard/js/modules/auth/services/authorisation.js'
    '/assets/dashboard/js/modules/auth/controllers/base.js'
    '/assets/dashboard/js/modules/auth/directives/access.js'
    '/assets/dashboard/js/modules/auth/run.js'
    '/assets/dashboard/js/partials/toolbar/init.js'
    '/assets/dashboard/js/partials/toolbar/toolbar.js'
    '/assets/dashboard/js/partials/sidebar/init.js'
    '/assets/dashboard/js/partials/sidebar/sidebar.js'
    '/assets/dashboard/js/app.js'
    '/assets/dashboard/js/controller.js'
    '/assets/dashboard/js/directives.js'
    '/assets/dashboard/js/routes.js'
    '/assets/js/libs/form.js'
  ]
  css: [
    '/bower/material-design-iconic-font/dist/css/material-design-iconic-font.min.css'
    '/bower/angular-loading-bar/build/loading-bar.min.css'
    '/bower/intro.js/minified/introjs.min.css'
    '/bower/bootstrap-sweetalert/lib/sweet-alert.css'
    '/assets/vendors/vendors/fullcalendar/fullcalendar.css'
    '/assets/vendors/vendors/animate-css/animate.min.css'
    '/assets/vendors/vendors/socicon/socicon.min.css'
    '/bower/chartist/dist/chartist.min.css'
    '/assets/vendors/css/app.min.1.css'
    '/assets/vendors/css/app.min.2.css'
    '/assets/css/main.css'
  ]
production =
  js: [ '/assets/js/libs/analytics.js' ]

staging =
  js: [ '/assets/js/libs/analytics.js' ]

module.exports =
  development:
    main:
      js: _.union([], core.js, dashboard.js)
      css: dashboard.css
    app:
      js: _.union([], core.js, app.js)
  test:
    main:
      js: _.union([], core.js, dashboard.js)
      css: dashboard.css
    app:
      js: _.union([], core.js, app.js)
  production:
    main:
      js: _.union([], core.js, dashboard.js, production.js)
      css: dashboard.css
    app:
      js: _.union([], core.js, app.js, production.js)
  staging:
    main:
      js: _.union([], core.js, dashboard.js, production.js)
      css: dashboard.css
    app:
      js: _.union([], core.js, app.js, production.js)
