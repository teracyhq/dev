#
# Cookbook Name:: nvm
# Recipe:: default
#
# Copyright 2013, HipSnip Limited
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

# If user install is true, nvm will be installed in the home directory of
# the user configured in node['nvm']['user']. If false, the directory
# attribute will be used.
default['nvm']['user_install'] = false
default['nvm']['user_home_dir'] = nil
# Only used if user_install is false
default['nvm']['directory'] = '/usr/local/src/nvm'
default['nvm']['repository'] = 'git://github.com/creationix/nvm.git'
default['nvm']['reference'] = 'master'
default['nvm']['source'] = 'source /etc/profile.d/nvm.sh'
default['nvm']['install_deps_to_build_from_source'] = true
default['nvm']['user'] = 'root'
default['nvm']['group'] = 'root'
