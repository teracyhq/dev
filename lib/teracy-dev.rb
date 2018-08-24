# to use teracy-dev, just require it: require 'teracy-dev'
# and it will load all the required modules loaded here

require_relative 'teracy-dev/logging'
require_relative 'teracy-dev/loader'
require_relative 'teracy-dev/extension/manager'


# define public APIs here
module TeracyDev

  BASE_DIR = File.join(File.dirname(__FILE__), '..')

  EXTENSION_ENTRY_PATH = ENV['TERACY_DEV_EXTENSION_ENTRY_PATH'] ||= 'workspace/teracy-dev-entry'

  DEFAULT_EXTENSION_LOOKUP_PATH = 'extensions' # relative to the Vagrantfile

  @@logger = TeracyDev::Logging.logger_for(self)
  # we can only create one Loader instance and accessible on this only
  @@loader = TeracyDev::Loader.new

  def self.register_processor(processor)
    @@loader.processorsManager.register(processor)
  end


  def self.register_configurator(configurator)
    @@loader.configManager.register(configurator)
  end

  @@loader.start

end
