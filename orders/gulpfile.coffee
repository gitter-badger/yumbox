gulp       = require 'gulp'
util       = require 'gulp-util'
newer      = require 'gulp-newer'
coffee     = require 'gulp-coffee'

gulp.task 'orders:build', ->
  
  src = 'src/**'
  dest = 'build'

  gulp.src( src )
    .pipe( newer {dest: dest, ext: '.js'} )
    .pipe( coffee().on('error', util.log) )
    .pipe( gulp.dest dest )

