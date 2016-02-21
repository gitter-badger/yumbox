gulp       = require 'gulp'
exec       = require 'gulp-exec'
util       = require 'gulp-util'
newer      = require 'gulp-newer'
argv       = require('yargs').argv

# ## Prerender pages
#
# Prerender all web pages. The home page url and destination should be passed. You should have PhantomJS installed on your machine and it uses [phantom.coffee script](phantom.html) internally to do its task.
#
# @example
#   gulp web:prerender -u='http://site.com/' -o='/var/www/snapshots'
#   gulp web:prerender -u='http://localhost:3000' -o='./snapshots'
#   gulp web:prerender -u='http://localhost:3000/#!/' -o='/var/www/tipi.me/snapshots'
#   gulp web:prerender -u='http://localhost:3000/#!/' -o='/var/www/tipi.me/snapshots' -l=1
#
gulp.task 'web:prerender', ->
  console.log "Creating snapshots #{argv.u} ====> #{argv.o}"

  reportOptions = {
    err: true
    stderr: true
    stdout: true 
  }
  gulp.src('./tasks')
    .pipe( exec "cd <%= file.path %> && coffee -c phantom.coffee && phantomjs phantom.js '#{argv.u}' '#{argv.o}' '#{argv.l}'", {continueOnError: false} )
    .pipe( exec.reporter reportOptions )
  
