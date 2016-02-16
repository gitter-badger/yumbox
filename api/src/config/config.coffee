Path = require 'path'
Yaml = require 'yml'

module.exports = {
  config: Yaml.load __dirname + "/config.yml"
  defaults: Yaml.load __dirname + "/defaults.yml"
}
