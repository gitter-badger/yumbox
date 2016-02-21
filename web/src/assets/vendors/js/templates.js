angular.module('materialAdmin').run(['$templateCache', function($templateCache) {
  'use strict';

  $templateCache.put('includes/chat.html',
    "<div class=\"chat-search\"><div class=\"fg-line\"><input type=\"text\" class=\"form-control\" placeholder=\"Search People\"></div></div><div class=\"listview\"><a class=\"lv-item\" href=\"\"><div class=\"media\"><div class=\"pull-left p-relative\"><img class=\"lv-img-sm\" src=\"img/profile-pics/2.jpg\" alt=\"\"> <i class=\"chat-status-busy\"></i></div><div class=\"media-body\"><div class=\"lv-title\">Jonathan Morris</div><small class=\"lv-small\">Available</small></div></div></a> <a class=\"lv-item\" href=\"\"><div class=\"media\"><div class=\"pull-left\"><img class=\"lv-img-sm\" src=\"img/profile-pics/1.jpg\" alt=\"\"></div><div class=\"media-body\"><div class=\"lv-title\">David Belle</div><small class=\"lv-small\">Last seen 3 hours ago</small></div></div></a> <a class=\"lv-item\" href=\"\"><div class=\"media\"><div class=\"pull-left p-relative\"><img class=\"lv-img-sm\" src=\"img/profile-pics/3.jpg\" alt=\"\"> <i class=\"chat-status-online\"></i></div><div class=\"media-body\"><div class=\"lv-title\">Fredric Mitchell Jr.</div><small class=\"lv-small\">Availble</small></div></div></a> <a class=\"lv-item\" href=\"\"><div class=\"media\"><div class=\"pull-left p-relative\"><img class=\"lv-img-sm\" src=\"img/profile-pics/4.jpg\" alt=\"\"> <i class=\"chat-status-online\"></i></div><div class=\"media-body\"><div class=\"lv-title\">Glenn Jecobs</div><small class=\"lv-small\">Availble</small></div></div></a> <a class=\"lv-item\" href=\"\"><div class=\"media\"><div class=\"pull-left\"><img class=\"lv-img-sm\" src=\"img/profile-pics/5.jpg\" alt=\"\"></div><div class=\"media-body\"><div class=\"lv-title\">Bill Phillips</div><small class=\"lv-small\">Last seen 3 days ago</small></div></div></a> <a class=\"lv-item\" href=\"\"><div class=\"media\"><div class=\"pull-left\"><img class=\"lv-img-sm\" src=\"img/profile-pics/6.jpg\" alt=\"\"></div><div class=\"media-body\"><div class=\"lv-title\">Wendy Mitchell</div><small class=\"lv-small\">Last seen 2 minutes ago</small></div></div></a> <a class=\"lv-item\" href=\"\"><div class=\"media\"><div class=\"pull-left p-relative\"><img class=\"lv-img-sm\" src=\"img/profile-pics/7.jpg\" alt=\"\"> <i class=\"chat-status-busy\"></i></div><div class=\"media-body\"><div class=\"lv-title\">Teena Bell Ann</div><small class=\"lv-small\">Busy</small></div></div></a></div>"
  );


  $templateCache.put('includes/footer.html',
    "Copyright &copy; 2015 Material Admin<ul class=\"f-menu\"><li><a href=\"\">Home</a></li><li><a href=\"\">Dashboard</a></li><li><a href=\"\">Reports</a></li><li><a href=\"\">Support</a></li><li><a href=\"\">Contact</a></li></ul>"
  );


  $templateCache.put('includes/header.html',
    "<ul class=\"header-inner\"><li id=\"menu-trigger\" data-target=\"mainmenu\" data-toggle-sidebar data-model-left=\"mactrl.sidebarToggle.left\" data-ng-class=\"{ 'open': mactrl.sidebarToggle.left === true }\"><div class=\"line-wrap\"><div class=\"line top\"></div><div class=\"line center\"></div><div class=\"line bottom\"></div></div></li><li class=\"logo hidden-xs\"><a href=\"index.html\">Material Admin {{ layoutSS }}</a></li><li class=\"pull-right\"><ul class=\"top-menu\"><li id=\"toggle-width\"><div class=\"toggle-switch\"><input id=\"tw-switch\" type=\"checkbox\" hidden data-change-layout=\"mactrl.layoutType\"><label for=\"tw-switch\" class=\"ts-helper\"></label></div></li><li id=\"top-search\"><a class=\"tm-search\" href=\"\" data-ng-click=\"hctrl.openSearch()\"></a></li><li class=\"dropdown\"><a data-toggle=\"dropdown\" class=\"tm-message\" href=\"\"><i class=\"tmn-counts\">6</i></a><div class=\"dropdown-menu dropdown-menu-lg stop-propagate pull-right\"><div class=\"listview\"><div class=\"lv-header\">Messages</div><div class=\"lv-body c-overflow\"><a class=\"lv-item\" ng-href=\"\" ng-repeat=\"w in hctrl.messageResult.list\"><div class=\"media\"><div class=\"pull-left\"><img class=\"lv-img-sm\" ng-src=\"img/profile-pics/{{ w.img }}\" alt=\"\"></div><div class=\"media-body\"><div class=\"lv-title\">{{ w.user }}</div><small class=\"lv-small\">{{ w.text }}</small></div></div></a></div><a class=\"lv-footer\" href=\"\">View All</a></div></div></li><li class=\"dropdown\"><a data-toggle=\"dropdown\" class=\"tm-notification\" href=\"\"><i class=\"tmn-counts\">9</i></a><div class=\"dropdown-menu dropdown-menu-lg stop-propagate pull-right\"><div class=\"listview\" id=\"notifications\"><div class=\"lv-header\">Notification<ul class=\"actions\"><li class=\"dropdown\"><a href=\"\" data-ng-click=\"hctrl.clearNotification($event)\"><i class=\"md md-done-all\"></i></a></li></ul></div><div class=\"lv-body c-overflow\"><a class=\"lv-item\" ng-href=\"\" ng-repeat=\"w in hctrl.messageResult.list\"><div class=\"media\"><div class=\"pull-left\"><img class=\"lv-img-sm\" ng-src=\"img/profile-pics/{{ w.img }}\" alt=\"\"></div><div class=\"media-body\"><div class=\"lv-title\">{{ w.user }}</div><small class=\"lv-small\">{{ w.text }}</small></div></div></a></div><a class=\"lv-footer\" href=\"\">View Previous</a></div></div></li><li class=\"dropdown hidden-xs\"><a data-toggle=\"dropdown\" class=\"tm-task\" href=\"\"><i class=\"tmn-counts\">2</i></a><div class=\"dropdown-menu pull-right dropdown-menu-lg\"><div class=\"listview\"><div class=\"lv-header\">Tasks</div><div class=\"lv-body\"><div class=\"lv-item\"><div class=\"lv-title m-b-5\">HTML5 Validation Report</div><div class=\"progress\"><div class=\"progress-bar\" role=\"progressbar\" aria-valuenow=\"95\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 95%\"><span class=\"sr-only\">95% Complete (success)</span></div></div></div><div class=\"lv-item\"><div class=\"lv-title m-b-5\">Google Chrome Extension</div><div class=\"progress\"><div class=\"progress-bar progress-bar-success\" role=\"progressbar\" aria-valuenow=\"80\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 80%\"><span class=\"sr-only\">80% Complete (success)</span></div></div></div><div class=\"lv-item\"><div class=\"lv-title m-b-5\">Social Intranet Projects</div><div class=\"progress\"><div class=\"progress-bar progress-bar-info\" role=\"progressbar\" aria-valuenow=\"20\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 20%\"><span class=\"sr-only\">20% Complete</span></div></div></div><div class=\"lv-item\"><div class=\"lv-title m-b-5\">Bootstrap Admin Template</div><div class=\"progress\"><div class=\"progress-bar progress-bar-warning\" role=\"progressbar\" aria-valuenow=\"60\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 60%\"><span class=\"sr-only\">60% Complete (warning)</span></div></div></div><div class=\"lv-item\"><div class=\"lv-title m-b-5\">Youtube Client App</div><div class=\"progress\"><div class=\"progress-bar progress-bar-danger\" role=\"progressbar\" aria-valuenow=\"80\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 80%\"><span class=\"sr-only\">80% Complete (danger)</span></div></div></div></div><a class=\"lv-footer\" href=\"\">View All</a></div></div></li><li class=\"dropdown\"><a data-toggle=\"dropdown\" class=\"tm-settings\" href=\"\"></a><ul class=\"dropdown-menu dm-icon pull-right\"><li><a data-ng-click=\"hctrl.fullScreen()\" href=\"\"><i class=\"md md-fullscreen\"></i> Toggle Fullscreen</a></li><li><a data-ng-click=\"hctrl.clearLocalStorage()\" href=\"\"><i class=\"md md-delete\"></i> Clear Local Storage</a></li><li><a href=\"\"><i class=\"md md-person\"></i> Privacy Settings</a></li><li><a href=\"\"><i class=\"md md-settings\"></i> Other Settings</a></li></ul></li><li class=\"hidden-xs\" data-target=\"chat\" data-toggle-sidebar data-model-right=\"mactrl.sidebarToggle.right\" data-ng-class=\"{ 'open': mactrl.sidebarToggle.right === true }\"><a class=\"tm-chat\" href=\"\"></a></li></ul></li></ul><!-- Top Search Content --><div id=\"top-search-wrap\"><input type=\"text\"> <i id=\"top-search-close\" data-ng-click=\"hctrl.closeSearch()\">&times;</i></div>"
  );


  $templateCache.put('includes/profile-menu.html',
    "<li class=\"btn-wave\" data-ui-sref-active=\"active\"><a data-ui-sref=\"pages.profile.profile-about\">About</a></li><li class=\"btn-wave\" data-ui-sref-active=\"active\"><a data-ui-sref=\"pages.profile.profile-timeline\">Timeline</a></li><li class=\"btn-wave\" data-ui-sref-active=\"active\"><a data-ui-sref=\"pages.profile.profile-photos\">Photos</a></li><li class=\"btn-wave\" data-ui-sref-active=\"active\"><a data-ui-sref=\"pages.profile.profile-connections\">Connections</a></li>"
  );


  $templateCache.put('includes/sidebar-left.html',
    "<div class=\"sidebar-inner c-overflow\"><div class=\"profile-menu\"><a href=\"\" toggle-submenu><div class=\"profile-pic\"><img src=\"img/profile-pics/1.jpg\" alt=\"\"></div><div class=\"profile-info\">Malinda Hollaway <i class=\"md md-arrow-drop-down\"></i></div></a><ul class=\"main-menu\"><li><a href=\"profile-about.html\"><i class=\"md md-person\"></i> View Profile</a></li><li><a href=\"\"><i class=\"md md-settings-input-antenna\"></i> Privacy Settings</a></li><li><a href=\"\"><i class=\"md md-settings\"></i> Settings</a></li><li><a href=\"\"><i class=\"md md-history\"></i> Logout</a></li></ul></div><ul class=\"main-menu\"><li data-ui-sref-active=\"active\"><a data-ui-sref=\"home\" data-ng-click=\"mactrl.sidebarStat($event)\"><i class=\"md md-home\"></i> Home</a></li><li data-ui-sref-active=\"active\"><a data-ui-sref=\"typography\" data-ng-click=\"mactrl.sidebarStat($event)\"><i class=\"md md-format-underline\"></i> Typography</a></li><li class=\"sub-menu\" data-ng-class=\"{ 'active toggled': mactrl.$state.includes('widgets') }\"><a href=\"\" toggle-submenu><i class=\"md md-now-widgets\"></i> Widgets</a><ul><li><a data-ui-sref-active=\"active\" data-ui-sref=\"widgets.widget-templates\" data-ng-click=\"mactrl.sidebarStat($event)\">Templates</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"widgets.widgets\" data-ng-click=\"mactrl.sidebarStat($event)\">Widgets</a></li></ul></li><li class=\"sub-menu\" data-ng-class=\"{ 'active toggled': mactrl.$state.includes('tables') }\"><a href=\"\" toggle-submenu><i class=\"md md-view-list\"></i> Tables</a><ul><li><a data-ui-sref-active=\"active\" data-ui-sref=\"tables.tables\" data-ng-click=\"mactrl.sidebarStat($event)\">Normal Tables</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"tables.data-tables\" data-ng-click=\"mactrl.sidebarStat($event)\">Data Tables</a></li></ul></li><li class=\"sub-menu\" data-ng-class=\"{ 'active toggled': mactrl.$state.includes('form') }\"><a href=\"\" toggle-submenu><i class=\"md md-my-library-books\"></i> Forms</a><ul><li><a data-ui-sref-active=\"active\" data-ui-sref=\"form.basic-form-elements\" data-ng-click=\"mactrl.sidebarStat($event)\">Basic Form Elements</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"form.form-components\" data-ng-click=\"mactrl.sidebarStat($event)\">Form Components</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"form.form-examples\" data-ng-click=\"mactrl.sidebarStat($event)\">Form Examples</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"form.form-validations\" data-ng-click=\"mactrl.sidebarStat($event)\">Form Validation</a></li></ul></li><li class=\"sub-menu\" data-ng-class=\"{ 'active toggled': mactrl.$state.includes('user-interface') }\"><a href=\"\" toggle-submenu><i class=\"md md-swap-calls\"></i>User Interface</a><ul><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.colors\" data-ng-click=\"mactrl.sidebarStat($event)\">Colors</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.animations\" data-ng-click=\"mactrl.sidebarStat($event)\">Animations</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.box-shadow\" data-ng-click=\"mactrl.sidebarStat($event)\">Box Shadow</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.buttons\" data-ng-click=\"mactrl.sidebarStat($event)\">Buttons</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.icons\" data-ng-click=\"mactrl.sidebarStat($event)\">Icons</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.alerts\" data-ng-click=\"mactrl.sidebarStat($event)\">Alerts</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.notifications-dialogs\" data-ng-click=\"mactrl.sidebarStat($event)\">Notifications & Dialogs</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.media\" data-ng-click=\"mactrl.sidebarStat($event)\">Media</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.components\" data-ng-click=\"mactrl.sidebarStat($event)\">Components</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"user-interface.other-components\" data-ng-click=\"mactrl.sidebarStat($event)\">Others</a></li></ul></li><li class=\"sub-menu\" data-ng-class=\"{ 'active toggled': mactrl.$state.includes('charts') }\"><a href=\"\" toggle-submenu><i class=\"md md-trending-up\"></i>Charts</a><ul><li><a data-ui-sref-active=\"active\" data-ui-sref=\"charts.flot-charts\" data-ng-click=\"mactrl.sidebarStat($event)\">Flot Charts</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"charts.other-charts\" data-ng-click=\"mactrl.sidebarStat($event)\">Other Charts</a></li></ul></li><li data-ui-sref-active=\"active\"><a data-ui-sref=\"calendar\" data-ng-click=\"mactrl.sidebarStat($event)\"><i class=\"md md-today\"></i> Calendar</a></li><li data-ui-sref-active=\"active\"><a data-ui-sref=\"generic-classes\" data-ng-click=\"mactrl.sidebarStat($event)\"><i class=\"md md-layers\"></i> Generic Classes</a></li><li class=\"sub-menu\" data-ng-class=\"{ 'active toggled': mactrl.$state.includes('pages') }\"><a href=\"\" toggle-submenu><i class=\"md md-content-copy\"></i> Sample Pages</a><ul><li><a data-ui-sref-active=\"active\" data-ui-sref=\"pages.profile.profile-about\" data-ng-click=\"mactrl.sidebarStat($event)\">Profile</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"pages.listview\" data-ng-click=\"mactrl.sidebarStat($event)\">List View</a></li><li><a data-ui-sref-active=\"active\" data-ui-sref=\"pages.messages\" data-ng-click=\"mactrl.sidebarStat($event)\">Messages</a></li><li><a href=\"login.html\">Login and Sign Up</a></li><li><a href=\"404.html\">Error 404</a></li></ul></li></ul></div>"
  );


  $templateCache.put('includes/templates.html',
    ""
  );

}]);
