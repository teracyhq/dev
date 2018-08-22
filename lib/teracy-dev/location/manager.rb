require_relative 'git_synch'

module TeracyDev
  module Location
    class Manager
      @@synch_list = [GitSynch.new]

      def self.sync(location, sync_existing = true)
       @@synch_list.each do |synch|
         synch.sync(location, sync_existing)
       end
      end
    end
  end
end
