(function(){var e,s;s=window.sys,s.modules.bookings={name:"bookings",dependencies:["angularMoment","ui.bootstrap.datetimepicker"],constants:{},controllers:{index:{name:"bookingsIndexCtrl",inject:["$scope","$stateParams","$http"]}},services:{},directives:{},endpoints:{list:"/api/v1/dashboard/bookings",create:"/api/v1/dashboard/bookings",get:"/api/v1/dashboard/bookings/:id"},events:{},states:{index:{name:"bookings",config:{access:["hostel"],url:"/bookings",templateUrl:"views/modules/bookings/html/index",resolve:{loadPlugin:["$ocLazyLoad",function(e){return e.load([{name:"css",insertBefore:"link",files:["bower/angular-bootstrap-datetimepicker/src/css/datetimepicker.css"]}])}]}}}}},e=angular.module(s.modules.bookings.name,s.modules.bookings.dependencies)}).call(this);