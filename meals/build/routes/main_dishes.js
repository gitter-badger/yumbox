(function() {
  var MainDishValidator;

  MainDishValidator = require('../models/mainDishValidator');

  module.exports = function(server, options) {
    var MainDish;
    MainDish = require('../handlers/main_dishes')(server, options);
    return [
      {
        method: 'POST',
        path: '/v1/dashboard/main_dishes',
        config: {
          handler: MainDish.dashboard.create,
          validate: MainDishValidator.prototype.create,
          payload: {
            output: 'stream'
          },
          description: 'Create a main meal.',
          tags: ['meal', 'dashboard', 'main_dish', 'create']
        }
      }, {
        method: 'GET',
        path: '/v1/dashboard/main_dishes',
        config: {
          handler: MainDish.dashboard.list_all,
          validate: MainDishValidator.prototype.get,
          description: 'list main dishes.',
          tags: ['meal', 'dashboard', 'main_dish', 'list']
        }
      }, {
        method: 'GET',
        path: '/v1/dashboard/main_dishes/{key}',
        config: {
          handler: MainDish.dashboard.detail,
          validate: MainDishValidator.prototype.detail,
          description: 'get datail of a main meal.',
          tags: ['meal', 'dashboard', 'main_dish', 'detail']
        }
      }, {
        method: 'PUT',
        path: '/v1/dashboard/main_dishes/{key}/toggle',
        config: {
          handler: MainDish.dashboard.toggle_availabilitty,
          validate: MainDishValidator.prototype.toggle,
          description: 'toggle maindish availability',
          tags: ['main_dish', 'update', 'toggle', 'unavailable', 'available']
        }
      }, {
        method: 'PUT',
        path: '/v1/dashboard/main_dishes/{key}',
        config: {
          handler: MainDish.dashboard.edit,
          validate: MainDishValidator.prototype.edit,
          description: 'Updates maindish',
          tags: ['main_dish', 'update', 'edit']
        }
      }, {
        method: 'DELETE',
        path: '/v1/dashboard/main_dishes/{key}',
        config: {
          handler: MainDish.dashboard.remove,
          validate: MainDishValidator.prototype["delete"],
          description: 'remove a main dish',
          tags: ['meal', 'dashboard', 'main_dish', 'delete']
        }
      }, {
        method: 'POST',
        path: '/v1/dashboard/main_dishes/{key}/photo',
        config: {
          handler: MainDish.dashboard.add_photo,
          validate: MainDishValidator.prototype.add_photo,
          payload: {
            output: 'stream'
          },
          description: 'add a photo to main dish',
          tags: ['meal', 'dashboard', 'main_dish', 'photo']
        }
      }
    ];
  };

}).call(this);
