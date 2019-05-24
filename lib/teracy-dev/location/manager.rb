require_relative '../logging'

module TeracyDev
  module Location
    class Manager
      @synch_list = []
      @logger = TeracyDev::Logging.logger_for(self)

      # return true if sync action is carried out, otherwise, return false
      def self.sync(location_conf, sync_existing = true, force = false)
        updated = false
        timer_start = Time.now
        return false if !force && !sync_required?

        @synch_list.each do |synch|
          updated = true if synch.sync(location_conf, sync_existing) == true
        end

        timer_end = Time.now
        finished_time = timer_end - timer_start
        @logger.debug("sync finished in #{finished_time}s with updated: " \
        "#{updated}, location_conf: #{location_conf}")
        updated
      end

      # add synchronization which implements sync method
      # @since v0.6.0-b1
      def self.add_synch(synch)
        if synch.respond_to?(:sync)
          @synch_list << synch
          @logger.debug("synch: #{synch} added")
        else
          @logger.warn("#{synch} ignored, must implement sync method")
        end
      end

      def self.sync_required?
        ARGV.include?('up') || ARGV.include?('status') || ARGV.include?('reload')
      end
    end
  end
end
