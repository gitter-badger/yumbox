module.exports = (server, options) ->

  [
    {
      method: 'GET'
      path: '/'
      config:
        handler: (request, reply) ->
          reply.view 'dashboard/index'
        description: 'Load main/only page of website.'
        tags: ['web']
    }
    {
      method: 'GET'
      path: '/views/{path*}'
      config: {
        handler: (request, reply) ->
          reply.view "dashboard/#{request.params.path}"
        description: 'Load html, jade views.'
        tags: ['web', 'assets']
      }
    }
    {
      method: 'GET'
      path: '/assets/defaults.js'
      config: {
        handler: (request, reply) ->
          reply "window.sys = { defaults: #{JSON.stringify options.web} }"
        description: 'Load js files'
        tags: ['web', 'js']
      }
    }
    {
      method: 'GET'
      path: '/assets/dashboard/js/{path*}'
      config: {
        handler: { directory: { path: __dirname + '/../dashboard' } }
        description: 'Load js files'
        tags: ['web', 'js']
      }
    }
    {
      method: 'GET'
      path: '/assets/js/{path*}'
      config: {
        handler: { directory: { path: __dirname + '/../' } }
        description: 'Load js files from libs'
        tags: ['web', 'js']
      }
    }
  ]
