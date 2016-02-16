_ = require 'lodash'
fs = require 'fs'
Path = require 'path'

gulp     = require 'gulp'
exec     = require 'gulp-exec'
template = require 'gulp-template'
util     = require 'gulp-util'


desc = "Create a new plugin directory e.g. gulp api:create -n=blog"
gulp.task 'api:create', desc, ->
  
  argv = require('yargs').alias('n', 'name').argv
  return console.warn "stage should be set to 'test' or 'production'" if not argv.name?
  root = Path.join __dirname, '../../'
  name = argv.name
  cName = name.charAt(0).toUpperCase() + name.slice(1)
  path_name = Path.join root, name
  templates = Path.join root, 'api/tasks/plugin_template'
  Path.join root, name

  reportOptions = {
    err: true
    stderr: true
    stdout: true 
  }
  
  if ! fs.existsSync path_name
    gulp.src(templates+'/**')
      .pipe( exec "mkdir -p #{path_name}", {continueOnError: false} )
      .pipe( exec.reporter reportOptions )
      .pipe( template { name: name, cName: cName } )
      .pipe( gulp.dest path_name )

    util.log "\n\n 1) Modify these files in 'api/' to reflect your new plugin:\n 
             \n #{util.colors.green 'vim tasks/config.yml'}\n
             \n      plugins:
             \n        #{util.colors.green "#{name}: tipi.#{name}"}\n
             \n #{util.colors.green 'vim src/config/plugins.coffee'}\n
             \n      api.register [ #{util.colors.green "{ register: require('tipi.#{name}'), options: { database: db } }"}, ....\n 
             \n 2) Now go to #{util.colors.green "cd #{root}api/"} try something like\n
             \n      #{util.colors.green("gulp api:link -n #{name} -s")}\n
             \n 3) Add '#{name}' to #{util.colors.green 'vim nodemon.json'} to restart server for changes in development.\n\n"
  else
    util.log util.colors.red "#{name} already exists!"

,{
  options: {
    'name': "name of folder to be created"
  }
}
