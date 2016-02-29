#
# Cookbook Name:: maven
# Provider:: settings
#
# Author:: Pushkar Raste <praste@bloomberg.net, pushkar.raste@gmail.com>
# Copyright 2014-2015, Bloomberg Inc.
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

# This is inspired by settings provider in https://github.com/RiotGames/nexus-cookbook

def load_current_resource
  @current_resource = Chef::Resource::MavenSettings.new(new_resource.path)
  @current_resource.value new_resource.value

  @current_resource
end

action :update do
  unless path_value_equals?(@current_resource.value)
    update_maven_settings
    new_resource.updated_by_last_action(true)
  end
end

private

def path_value_equals?(value)
  hashed_settings = maven_settings_hash

  *path_elements, setting_to_update = new_resource.path.split('.')
  path_elements.inject(hashed_settings, :fetch)[setting_to_update] == value
end

def maven_settings_hash
  require 'nori'
  Nori.new(parser: :rexml).parse(::File.open("#{node['maven']['m2_home']}/conf/settings.xml", 'r').read)
end

def update_maven_settings
  require 'gyoku'

  hashed_settings = maven_settings_hash

  *path_elements, setting_to_update = new_resource.path.split('.')
  path_elements.inject(hashed_settings, :fetch)[setting_to_update] = new_resource.value

  # Convert back to xml
  xmlized_updated_settings = Gyoku.xml(hashed_settings)

  # Empty tags end up with attribute xsi:nil="true", let's clean that up
  xmlized_updated_settings.gsub!(/xsi:nil="true"/, '')

  ::File.open("#{node['maven']['m2_home']}/conf/settings.xml", 'w+').write(xmlized_updated_settings)
end
