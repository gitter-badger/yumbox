_ = require 'lodash'

gulp = require 'gulp'
exec = require 'gulp-exec'
util = require 'gulp-util'
Yaml   = require 'yml'

gulp = require('gulp-help') gulp, { aliases: ['h', '?', '-h'] }

desc = "Link all plugin folders to main api folder as a dependency. "
gulp.task 'api:link', desc, ->
  argv = require('yargs').alias('n', 'name').argv
  reportOptions = {
    err: true
    stderr: true
    stdout: true 
  }
  root = '../'

  name = argv.name 

  config = Yaml.load __dirname + "/config.yml"
  plugins = config.plugins
  
  if name?
    current = plugins[name]
    (plugins={})[name] = current

  doer = ''
  doer = 'sudo' if argv.s 
  console.log "This will take a while to install npms and link below plugin(s):"
  cmds = _.map plugins, (n, p) ->
    console.log " - #{n}"
    "cd ../#{p} && #{doer} npm install && #{doer} npm link . && cd ../api && #{doer} npm link #{n}"
  cmd = cmds.join ' && '

  gulp.src(root)
    .pipe( exec cmd, {continueOnError: false} )
    .pipe( exec.reporter reportOptions )
,{
  options: {
    's': "it is a flag to show if the task should be run with sudo. to run with sudo do 'gulp api:link -s'"
    'n': "only link one plugin. e.g. gulp api:link -n blog"
  }
}
