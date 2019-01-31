# to use teracy-dev, just require it: require 'teracy-dev'
# and it will load all the required modules loaded here

require_relative 'teracy-dev/env'
require_relative 'teracy-dev/logging'
require_relative 'teracy-dev/loader'
require_relative 'teracy-dev/extension/manager'
require_relative 'teracy-dev/location/manager'

require_relative 'teracy-dev/logging/progname_acceptor'
require_relative 'teracy-dev/logging/mask_filter'
require_relative 'teracy-dev/location/git_synch'

# define public APIs here
module TeracyDev
  # TODO(hoatle): find a way to add warning log for these deprecated var
  # deprecated, use TeracyDev::Env instead
  BASE_DIR = File.join(File.dirname(__FILE__), '..')

  # deprecated, use TeracyDev::Env instead
  EXTENSION_ENTRY_PATH = ENV['TERACY_DEV_EXTENSION_ENTRY_PATH'] ||= 'workspace/teracy-dev-entry'

  # deprecated, use TeracyDev::Env instead
  DEFAULT_EXTENSION_LOOKUP_PATH = 'extensions'.freeze # relative to the Vagrantfile

  @logger = TeracyDev::Logging.logger_for(self)

  # we can only create one Loader instance and accessible on this only
  @loader = TeracyDev::Loader.new

  def self.register_processor(processor, weight = 5)
    @loader.processors_manager.register(processor, weight)
  end

  def self.register_configurator(configurator, weight = 5)
    @loader.config_manager.register(configurator, weight)
  end

  def self.init
    Logging.add_acceptor(Logging::PrognameAcceptor.new)
    Logging.add_filter(Logging::MaskFilter.new)
    Location::Manager.add_synch(Location::GitSynch.new)
    @loader.start
  end
end
