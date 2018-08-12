# some vagrant sub commands cause teracy-dev's malfunction and it's safe to not load tearcy-dev
unloadable_sub_commands = ['box', 'plugin']

if ARGV[0] && !unloadable_sub_commands.include?(ARGV[0])
  # add ./lib to ruby load path
  lib_dir = File.expand_path('./lib', __dir__)
  $LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

  require 'teracy-dev'

end
