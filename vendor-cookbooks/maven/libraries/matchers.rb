#
# Cookbook Name:: maven
# Library:: default
#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
#
# Copyright:: 2010-2015, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if defined?(ChefSpec)
  def install_maven_artifact(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:maven, :install, resource)
  end

  def put_maven_artifact(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:maven, :put, resource)
  end
end
