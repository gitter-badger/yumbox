(function(){var t,e;t=window.sys.modules.side_dishes,e=function(e){return e.state(t.states.index.name,t.states.index.config).state(t.states["new"].name,t.states["new"].config).state(t.states.show.name,t.states.show.config).state(t.states.edit.name,t.states.edit.config)},e.$inject=["$stateProvider"],angular.module(t.name).config(e)}).call(this);