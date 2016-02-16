_ = require 'lodash'

gulp   = require 'gulp'
exec   = require 'gulp-exec'
ssh    = require 'gulp-ssh'
util   = require 'gulp-util'
Yaml   = require 'yml'

desc = "Deploy to test or production servers. e.g. gulp api:deploy --stage=production"
gulp.task 'api:deploy', desc, ->

  argv = require('yargs').argv
  return console.warn "stage should be set to 'test' or 'production'" if not argv.stage?
  stage = argv.stage
  version = new Date().getTime()
  util.log "Deploying to #{stage} as", util.colors.green(" #{version}:")
  
  config = Yaml.load __dirname + "/deploy.yml", stage

  config.ssh.privateKey = require('fs').readFileSync config.ssh.privateKey
  ssh = ssh { ignoreErrors: false, sshConfig: config.ssh }

  util.log util.colors.green("shell logs can be found at"), util.colors.bgGreen("logs/gulp.ssh.log")

  current = "#{config.path}/current"
  release = "#{config.path}/releases/#{version}"
  shared  = "#{config.path}/shared"
  ssh.shell [ "mkdir -p #{shared}"
              "mkdir -p #{release}"
              "cd #{release}"
              "git clone #{config.git.remote} #{release}"
              "cd api" 
              "npm install ."
              "gulp --stage=deploy api:link"
              "cd #{current}"
              "#{config.stop}"
              "cd #{release}"
              "ln -s #{shared} #{release}/shared"
              "ln -s #{config.path}/config.yml #{release}/api/build/config/config.yml"
              "rm -f #{current}"
              "ln -s #{release} #{current}"
              "cd #{current}"
              "#{config.start}"
              "cd #{config.path}/releases/"
              "ls -d */ | sort -r | tail -n +#{config.history+1} | xargs rm -rf"
            ], {filePath: 'gulp.ssh.log'}
     .pipe( gulp.dest 'logs' )

,{
  options: {
    'stage': "set which deployment config should be loaded from deploy.yml."
  }
}
