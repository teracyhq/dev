require_relative '../logging'

require_relative 'git_synch'

module TeracyDev
  module Location
    class Manager
      @@synch_list = [GitSynch.new]
      @@logger = TeracyDev::Logging.logger_for(self)

      # return true if location is updated, otherwise, return false (no sync)
      def self.sync(location, sync_existing = true)
        updated = false
        timer_start = Time.now
        @@synch_list.each do |synch|
          if synch.sync(location, sync_existing) == true
            updated = true
          end
        end
        timer_end = Time.now
        @@logger.debug("sync finished in #{timer_end - timer_start}s with updated: #{updated}, location: #{location}")
        updated
      end
    end
  end
end
