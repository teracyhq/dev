require_relative 'git_synch'

module TeracyDev
  module Location
    class Manager
      @@synch_list = [GitSynch.new]

      # return true if location is updated, otherwise, return false (no sync)
      def self.sync(location, sync_existing = true)
        updated = false
        @@synch_list.each do |synch|
          if synch.sync(location, sync_existing) == true
            updated = true
          end
        end
        updated
      end
    end
  end
end
