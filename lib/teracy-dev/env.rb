module TeracyDev
  # runtime variable for teracy-dev
  # @since v0.6.0-a5
  class Env
    BASE_DIR = File.join(File.dirname(__FILE__), '..')

    EXTENSION_ENTRY_PATH = ENV['TERACY_DEV_EXTENSION_ENTRY_PATH'] ||= 'workspace/teracy-dev-entry'

    DEFAULT_EXTENSION_LOOKUP_PATH = 'extensions' # relative to the Vagrantfile
  end
end
