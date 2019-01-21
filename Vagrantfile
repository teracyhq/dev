# some vagrant sub commands cause teracy-dev's malfunction and it's safe to not load teracy-dev
unloadable_sub_commands = ['plugin']

if ARGV[0] && !unloadable_sub_commands.include?(ARGV[0])
  # add ./lib to ruby load path
  lib_dir = File.expand_path('./lib', __dir__)
  $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

  require 'teracy-dev/plugin'

  def init_system
    system_settings = YAML.load_file(File.join(File.dirname(__FILE__), 'system.yaml'))
    # versions requirements
    Vagrant.require_version system_settings['vagrant']['require_version']
    TeracyDev::Plugin.sync(system_settings['vagrant']['plugins'])
  end

  init_system

  begin
    require 'teracy-dev'
    TeracyDev.init
  rescue
    # add tracing for easier debugging and fixing
    puts $@
    raise
  end

end
