# extension file to extend teracy-dev's core (always loaded by configured)

# -*- mode: ruby -*-
# vi: set ft=ruby :

# extend the core here
# # add ./lib to ruby load path
lib_dir = File.expand_path('./lib', __dir__)
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'teracy-dev'
require 'teracy-dev/ext'

logger = TeracyDev::Logging.logger_for("ext")

# register custom configurator
TeracyDev.register_configurator(TeracyDev::Ext::PluginsConfig.new)
