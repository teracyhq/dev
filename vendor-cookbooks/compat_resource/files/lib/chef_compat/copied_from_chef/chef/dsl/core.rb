begin
  require 'chef/dsl/core'
rescue LoadError; end

require 'chef_compat/copied_from_chef'
class Chef
module ::ChefCompat
module CopiedFromChef
#--
# Author:: Adam Jacob (<adam@chef.io>)
# Author:: Christopher Walters (<cw@chef.io>)
# Copyright:: Copyright 2008-2016, 2009-2015 Chef Software, Inc.
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

require "chef_compat/copied_from_chef/chef/dsl/declare_resource"
require "chef_compat/copied_from_chef/chef/mixin/notifying_block"
require "chef_compat/copied_from_chef/chef/mixin/powershell_out"

class Chef < (defined?(::Chef) ? ::Chef : Object)
  module DSL
    CopiedFromChef.extend_chef_module(::Chef::DSL, self) if defined?(::Chef::DSL)
    # This is the "Core DSL" with various bits of Sugar that are mixed into core providers as well
    # as user LWRPs.  This module deliberately does not mixin the Resources or Defintions DSL bits
    # so that cookbooks are not injeting random things into the namespace of core providers.
    #
    # - If you are writing cookbooks:  you have come to the wrong place, please inject things into
    #   Chef::DSL::Recipe instead.
    #
    # - If you are writing core chef:  you have come to the right place, please drop your DSL modules
    #   into here.
    #
    module Core
      CopiedFromChef.extend_chef_module(::Chef::DSL::Core, self) if defined?(::Chef::DSL::Core)
      include Chef::DSL::DeclareResource
      include Chef::Mixin::NotifyingBlock
      include Chef::Mixin::PowershellOut
      include Chef::Mixin::ShellOut
    end
  end
end
end
end
end
