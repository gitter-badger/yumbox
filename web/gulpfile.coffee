gulp       = require 'gulp'

###
  - src
    - app (coffee, jade, js)
    - assets (scss, font, img)
    - assets.coffee
    - main.coffee
    - routes.coffee
  - build
    - app (js, jade)
    - assets (css, font, img)
    - assets.js
    - main.js
    - routes.js
  - test
  - node_modules
  - package.json
  - gulpfile.coffee
###

require './tasks/prerender'

gulp.task 'web:build', ->
  util       = require 'gulp-util'
  filter     = require 'gulp-filter'
  newer      = require 'gulp-newer'
  sass       = require 'gulp-sass'
  coffee     = require 'gulp-coffee'
  minifyCSS  = require 'gulp-minify-css'
  uglify     = require 'gulp-uglify'
  
  src  = 'src/**'
  dest = 'build'
  util.log 'building web plugin...'
  onlyCoffee = filter '**/*.coffee'
  onlyScss   = filter '**/*.scss'

  gulp.src( src )
    .pipe( onlyCoffee )
    .pipe( newer {dest: dest, ext: '.js'} )
    .pipe( coffee().on('error', util.log) )
    .pipe( uglify() )
    .pipe( onlyCoffee.restore() )
    .pipe( onlyScss )
    .pipe( newer {dest: dest, ext: '.css'} )
    .pipe( sass() )
    .pipe( minifyCSS() )
    .pipe( onlyScss.restore() )
    .pipe( newer dest )
    .pipe( gulp.dest dest )

