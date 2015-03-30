#
# Cookbook Name:: phpmyadmin
# Recipe:: default
#
# Copyright 2012, Panagiotis Papadomitsos
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'digest/sha1'

# PHP Recipe includes we already know PHPMyAdmin needs
#include_recipe 'php'
#include_recipe 'php::module_mbstring'
#include_recipe 'php::module_mcrypt'
#include_recipe 'php::module_gd'
#include_recipe 'php::module_mysql'

home = node['phpmyadmin']['home']
user = node['phpmyadmin']['user']
group = node['phpmyadmin']['group']
conf = "#{home}/config.inc.php"

group group do
	action [ :create, :manage ]
end

user user do
	action [ :create, :manage ]
	comment 'PHPMyAdmin User'
	gid group
	home home
	shell '/usr/sbin/nologin'
	supports :manage_home => true
end

directory home do
	owner user
	group group
	mode 00755
	recursive true
	action :create
end

directory node['phpmyadmin']['upload_dir'] do
	owner 'root'
	group 'root'
	mode 01777
	recursive true
	action :create
end

directory node['phpmyadmin']['save_dir'] do
	owner 'root'
	group 'root'
	mode 01777
	recursive true
	action :create
end

# Download the selected PHPMyAdmin archive
remote_file "#{Chef::Config['file_cache_path']}/phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages.tar.gz" do
  owner user
  group group
  mode 00644
	retries 5
	retry_delay 2
  action :create
  source "#{node['phpmyadmin']['mirror']}/#{node['phpmyadmin']['version']}/phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages.tar.gz"
  checksum node['phpmyadmin']['checksum']
end

bash 'extract-php-myadmin' do
	user user
	group group
	cwd home
	code <<-EOH
		rm -fr *
		tar xzf #{Chef::Config['file_cache_path']}/phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages.tar.gz
		mv phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages/* #{home}/
		rm -fr phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages
	EOH
	not_if { ::File.exists?("#{home}/RELEASE-DATE-#{node['phpmyadmin']['version']}")}
end

directory "#{home}/conf.d" do
	owner user
	group group
	mode 00755
	recursive true
	action :create
end

# Blowfish Secret - set it statically when running on Chef Solo via attribute
unless Chef::Config[:solo] || node['phpmyadmin']['blowfish_secret']
  node.set['phpmyadmin']['blowfish_secret'] = Digest::SHA1.hexdigest(IO.read('/dev/urandom', 2048))
  node.save
end

template "#{home}/config.inc.php" do
	source 'config.inc.php.erb'
	owner user
	group group
	mode 00644
end

if (node['phpmyadmin'].attribute?('fpm') && node['phpmyadmin']['fpm'])
 	php_fpm 'phpmyadmin' do
	  action :add
	  user user
	  group group
	  socket true
	  socket_path node['phpmyadmin']['socket']
	  socket_user user
	  socket_group group
	  socket_perms '0666'
	  start_servers 2
	  min_spare_servers 2
	  max_spare_servers 8
	  max_children 8
	  terminate_timeout (node['php']['ini_settings']['max_execution_time'].to_i + 20)
	  value_overrides({
	    :error_log => "#{node['php']['fpm_log_dir']}/phpmyadmin.log"
	  })
	end
end
