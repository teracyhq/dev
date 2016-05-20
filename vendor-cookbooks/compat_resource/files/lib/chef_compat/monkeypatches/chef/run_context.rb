require 'chef/run_context'
require 'chef_compat/monkeypatches/chef/resource_collection'

if Gem::Requirement.new("< 12.10.24").satisfied_by?(Gem::Version.new(Chef::VERSION))
  module ChefCompat
    module Monkeypatches
      module Chef
        module RunContext
          # for versions after we added intialize_child_state but before 12.10.24
          def initialize_child_state(*args)
            super
            @resource_collection.run_context = self
            @delayed_actions = []
          end
        end
      end
    end
  end

  class Chef
    class RunContext
      #
      # NOTE:  The root run_context is created long before we start monkeying around
      # with patching the class.  No child run context has been created yet.  This
      # still patches the root run_context and implements the new behaviors on it.
      #
      # This does affect our ability to patch methods like #initialize, since the
      # root has already been created and initialized, obviously.
      #

      unless method_defined?(:parent_run_context)
        attr_accessor :parent_run_context
      end

      unless method_defined?(:delayed_actions)
        def delayed_actions
          @delayed_actions ||= []
        end
      end

      unless method_defined?(:initialize_child_state)
        #
        # Copied verbatim from 12.10.24 Chef::RunContext
        #
        def initialize_child_state
          @audits = {}
          @resource_collection = Chef::ResourceCollection.new(self)
          @before_notification_collection = Hash.new { |h, k| h[k] = [] }
          @immediate_notification_collection = Hash.new { |h, k| h[k] = [] }
          @delayed_notification_collection = Hash.new { |h, k| h[k] = [] }
          @delayed_actions = []
        end
      else
        prepend ChefCompat::Monkeypatches::Chef::RunContext
      end

      unless method_defined?(:add_delayed_action)
        def add_delayed_action(notification)
          if delayed_actions.any? { |existing_notification| existing_notification.duplicates?(notification) }
            Chef::Log.info( "#{notification.notifying_resource} not queuing delayed action #{notification.action} on #{notification.resource}"\
                           " (delayed), as it's already been queued")
          else
            delayed_actions << notification
          end
        end
      end

      unless method_defined?(:create_child)
        def create_child
          result = dup
          result.parent_run_context = self
          result.initialize_child_state
          result
        end
      end
    end
  end
end
