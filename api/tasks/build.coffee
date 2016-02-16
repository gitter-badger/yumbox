_          = require 'lodash'

gulp       = require 'gulp'
exec       = require 'gulp-exec'
util       = require 'gulp-util'
filter     = require 'gulp-filter'
newer      = require 'gulp-newer'
coffee     = require 'gulp-coffee'
nodemon    = require 'gulp-nodemon'
replace    = require 'gulp-replace'
clean      = require 'gulp-clean'
Yaml       = require 'yml'

gulp = require('gulp-help') gulp, { aliases: ['h', '?', '-h'] }

nodemon_config = require '../nodemon.json'

plugin_names = ->
  config = Yaml.load __dirname + "/config.yml"
  _.keys config.plugins

build = (plugins, is_src)->
  reportOptions = {
    err: true
    stderr: true
    stdout: true
  }
  root = '../'
  
  swap_files plugins, is_src

  for name in plugins
    gulp.src(root+name)
      .pipe( exec "cd <%= file.path %> && gulp #{name}:build", {continueOnError: false} )
      .pipe( exec.reporter reportOptions )

swap_files = (plugins, is_src)->
  root = '../'
  
  plugins = _.difference plugins, ['web']
  

  if is_src
    src = 'build/main'
    out = 'src/main'
  else
    src = 'src/main'
    out = 'build/main'

  for name in plugins
    gulp.src(root+name+'/init.js')
      .pipe(replace src, out)
      .pipe(clean {force: true} )
      .pipe(gulp.dest(root+name))
 
gulp.task 'api:dependencies', false, ->

  build plugin_names(), false

gulp.task 'api:dependencies:web', false, ->

  build ['web'], true

gulp.task 'api:run:web', "Run project with only web plugin rebuild", ['api:dependencies:web'], ->

  swap_files plugin_names(), true
  dev_config = _.extend {}, nodemon_config, { script: 'src/server.coffee' }

  server = nodemon(dev_config)
    .on('exit', ['api:dependencies:web'])
    .on('restart', ->
      console.log('restarted!')
    )

gulp.task 'api:run:coffee', "Run project using coffee files", ->

  swap_files plugin_names(), true
  dev_config = _.extend {}, nodemon_config, { script: 'src/server.coffee' }

  server = nodemon(dev_config)
    .on('restart', ->
      console.log('restarted!')
    )

gulp.task 'api:build', false, ['api:dependencies'], ->
  
  src = 'src/**'
  dest = 'build'
  onlyCoffee = filter '**/*.coffee'

  gulp.src( src )
    .pipe( onlyCoffee )
    .pipe( newer {dest: dest, ext: '.js'} )
    .pipe( coffee().on('error', util.log) )
    .pipe( onlyCoffee.restore() )
    .pipe( gulp.dest dest )

gulp.task 'api:run', 'Run other tasks which builds all plugins and start a server and watches for changes', ['api:build'], ->

  server = nodemon(nodemon_config)
    .on('exit', ['api:build'])
    .on('restart', ->
      console.log('restarted!')
    )

,{
  aliases: ['api:start']
}
