#--
# Author:: Adam Jacob (<adam@chef.io>)
# Author:: Christopher Walters (<cw@chef.io>)
# Author:: Tim Hinderliter (<tim@chef.io>)
# Copyright:: Copyright 2008-2016, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# minimal monkeypatch necessary to implement the notifcation features
# of 12.10.x
#
# if before notifications are also pulled into this monkeypatch then it
# may simply be easier to copy the entire Chef::Runner class from 12.10.24
# into this file.
#
class Chef
  # == Chef::Runner
  # This class is responsible for executing the steps in a Chef run.
  class Runner

    def delayed_actions
      @run_context.delayed_actions
    end

    # Determine the appropriate provider for the given resource, then
    # execute it.
    def run_action(resource, action, notification_type = nil, notifying_resource = nil)
      # Actually run the action for realsies
      resource.run_action(action, notification_type, notifying_resource)

      # Execute any immediate and queue up any delayed notifications
      # associated with the resource, but only if it was updated *this time*
      # we ran an action on it.
      if resource.updated_by_last_action?
        run_context.immediate_notifications(resource).each do |notification|
          Chef::Log.info("#{resource} sending #{notification.action} action to #{notification.resource} (immediate)")
          run_action(notification.resource, notification.action, :immediate, resource)
        end

        run_context.delayed_notifications(resource).each do |notification|
          # send the notification to the run_context of the receiving resource
          notification.resource.run_context.add_delayed_action(notification)
        end
      end
    end

  end
end
