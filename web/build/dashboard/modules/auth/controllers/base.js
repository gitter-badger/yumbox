(function(){var e,n;n=sys.modules.auth,e=function(e,s,r,t,i,a,u){var l;return l={assign:function(){return s.logged_in=!1,e.storage=a,e.state=r.current.currentTab,e.isBusy=!1,e.failed=!1,e.user={email:"",password:""}},retrieveAccount:function(){return a.account?e.user.email=a.account.email:void 0},events:{assign:function(){return e.login=l.events.login,e.signup=l.events.signup,e.clear=l.events.clear},clear:function(){return a.account=null},login:function(){return e.failed=!1,e.isBusy?void 0:(e.isBusy=!0,t.login(e.user.email,e.user.password).then(function(e){return l.events.logged(e.doc_key)},function(n){return e.error=n,e.failed=!0})["finally"](function(){return e.isBusy=!1}))},logged:function(n){return a.account={email:e.user.email,doc_key:n},s.logged_in=!0,r.go(i.homeState)},signup:function(){var s;return""===e.user.email||""===e.user.name||""===e.user.password?e.terms_failed="Please fill all fields.":e.terms_accepted?(e.terms_failed="",s={name:e.user.name,email:e.user.email,password:e.user.password},u.post(n.endpoints.signup,s).success(function(e){return t.logged(e.data),l.events.logged(e.data.doc_key)}).error(function(n,s){return null!=n.message?e.terms_failed=n.message.split("[")[1].split("]")[0]:(console.log(n,s),e.terms_failed="This email is already registered.")})):e.terms_failed="Please accept the terms first."}}},l.assign(),l.retrieveAccount(),l.events.assign()},e.$inject=n.controllers.base.inject,angular.module(n.name).controller(n.controllers.base.name,e)}).call(this);