argv = require('yargs').argv

if argv.stage != 'deploy'
  require './tasks/build'
  require './tasks/deploy'
  require './tasks/generator'

require './tasks/link'
