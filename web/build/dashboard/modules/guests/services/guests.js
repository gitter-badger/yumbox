(function(){var n,e;n=window.sys.modules.guests,e=function(){var n,e;return e={checkins:[],checkouts:[]},n=function(n,e){var c;return c=null,angular.forEach(n,function(n,t){return(this.doc_key=e)?(c=n,!1):void 0}),c},{setCheckins:function(n){return e.checkins=n},setCheckouts:function(n){return e.checkouts=n},getCheckin:function(c){return n(e.checkins,c)},getCheckout:function(c){return n(e.checkouts,c)},getGuest:function(c){var t;return t=n(e.checkins,c),null===t&&(t=n(e.checkouts,c)),t}}},e.$inject=n.services.guests.inject,angular.module(n.name).factory(n.services.guests.name,e)}).call(this);