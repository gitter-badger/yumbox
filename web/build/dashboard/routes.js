(function(){var e,t,s;s=window.sys,e=angular.module(s.modules.app.name),t=function(e,t){return t.otherwise(s.modules.home.states.home.config.url),e.state(s.modules.app.states.app.name,{"abstract":!0,resolve:{authorize:[s.modules.auth.services.authentication,function(e){return console.log("authenticating on first load"),e.session()}]},template:"<div ui-view />"}).state(s.modules.home.states.home.name,s.modules.home.states.home.config).state(s.modules.app.states.panel.name,s.modules.app.states.panel.config).state(s.modules.app.states.page.name,s.modules.app.states.page.config)},t.$inject=["$stateProvider","$urlRouterProvider"],e.config(t)}).call(this);