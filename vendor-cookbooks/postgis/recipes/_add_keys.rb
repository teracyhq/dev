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

cookbook_file "#{Chef::Config[:file_cache_path]}/DAF764E2.key" do
  source "DAF764E2.key"
  mode "0600"
end

cookbook_file "#{Chef::Config[:file_cache_path]}/314DF160.key" do
  source "314DF160.key"
  mode "0600"
end

execute "apt-key adv --import #{Chef::Config[:file_cache_path]}/DAF764E2.key" do
  not_if 'apt-key list | grep "DAF764E2"'
end

execute "apt-key adv --import #{Chef::Config[:file_cache_path]}/314DF160.key" do
  not_if 'apt-key list | grep "314DF160"'
end
