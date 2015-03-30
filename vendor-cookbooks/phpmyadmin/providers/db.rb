#
# Cookbook Name:: phpmyadmin
# Provider:: db
#
# Copyright 2012, Panagiotis Papadomitsos
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

action :create do
	Chef::Log.info("Creating PHPMyAdmin database profile for: #{new_resource.name}")
	new_resource.hide_dbs = [ new_resource.hide_dbs ] if new_resource.hide_dbs.instance_of?(String)
	new_resource.updated_by_last_action(false)

	a = template "#{node['phpmyadmin']['home']}/conf.d/#{new_resource.name.downcase.gsub(' ','_')}.inc.php" do
		cookbook 'phpmyadmin'
		source 'dbinstance.inc.php.erb'
		owner node['phpmyadmin']['user']
		group node['phpmyadmin']['group']
		variables({
			:name => new_resource.name,
			:host => new_resource.host,
			:port => new_resource.port,
			:user => new_resource.username,
			:pass => new_resource.password,
			:hide_dbs => new_resource.hide_dbs,
			:pma_user => new_resource.pma_username,
			:pma_pass => new_resource.pma_password,
	        :pma_db => new_resource.pma_database,
	        :auth_type => new_resource.auth_type
		})
		mode 00640
	end

	new_resource.updated_by_last_action(a.updated_by_last_action?)

end

action :delete do
	Chef::Log.info("Removing PHPMyAdmin database profile for: #{new_resource.name}")
	new_resource.updated_by_last_action(false)

	a = file "#{node['phpmyadmin']['home']}/conf.d/#{new_resource.name.downcase.gsub(' ','_')}.inc.php" do
		action :delete
	end

	new_resource.updated_by_last_action(a.updated_by_last_action?)
	
end
