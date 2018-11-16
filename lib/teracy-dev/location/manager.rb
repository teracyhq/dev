require_relative '../logging'

require_relative 'git_synch'

module TeracyDev
  module Location
    class Manager
      @@synch_list = [GitSynch.new]
      @@logger = TeracyDev::Logging.logger_for(self)

      # return true if sync action is carried out, otherwise, return false
      def self.sync(location, sync_existing = true, force = false)
        updated = false
        timer_start = Time.now
        if !force && !sync_required?
          return false
        end
        @@synch_list.each do |synch|
          if synch.sync(location, sync_existing) == true
            updated = true
          end
        end
        timer_end = Time.now
        @@logger.debug("sync finished in #{timer_end - timer_start}s with updated: #{updated}, location: #{location}")
        updated
      end

      def self.sync_required?
        return ARGV.include?('up') || ARGV.include?('status') || ARGV.include?('reload')
      end
    end
  end
end
