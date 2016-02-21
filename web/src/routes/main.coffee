module.exports = (server, options) ->

  [
    {
      method: 'GET'
      path: '/sitemap.xml'
      config:
        handler:
          file: "#{__dirname}/../sitemap.xml"
    }
    {
      method: 'GET'
      path: '/favicon.ico'
      config: {
        handler: {
          file: "#{__dirname}/../assets/img/favicon.ico"
        }
      }
    }
    {
      method: 'GET'
      path: '/robots.txt'
      config: {
        handler: {
          file: "#{__dirname}/../robots.txt"
        }
      }
    }
    {
      method: '*'
      path: '/api/{path*}'
      config: {
        handler: {
          proxy: {
            passThrough: true
            localStatePassThrough: true
            mapUri: (request, callback) ->
              path = request.url.path
              url = "http://127.0.0.1:3100#{path.substring(path.indexOf('/api')+4)}"
              callback null, url
          }
        }
        description: 'Proxy to API server'
        tags: ['web', 'api', 'proxy']
      }
    }
    {
      method: 'GET'
      path: '/bower/{path*}'
      config: {
        handler: { directory: { path: __dirname + '/../../bower_components/' } }
        description: 'Load bower components files'
        tags: ['web', 'js', 'css', 'bower']
      }
    }
    {
      method: 'GET'
      path: '/assets/{path*}'
      config: {
        handler: { directory: { path: __dirname + '/../assets' } }
        description: 'Load assets.'
        tags: ['web', 'assets']
      }
    }
  ]
