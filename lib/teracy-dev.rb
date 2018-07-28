# to use teracy/dev, just require it: require 'teracy/dev'
# and it will load all the required modules loaded here

require_relative 'teracy-dev/logging'
require_relative 'teracy-dev/loader'


# define public APIs here
module TeracyDev

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
