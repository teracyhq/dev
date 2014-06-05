#
# Author::  Achim Rosenhagen (<a.rosenhagen@ffuenf.de>)
# Cookbook Name:: dotdeb
# Recipe:: default
#
# Copyright 2013, Achim Rosenhagen
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

if node['platform'] == 'debian'
	include_recipe "apt"
	# switch php versions
	if node['dotdeb']['php55']
		apt_repository "dotdeb-php55" do
			uri node['dotdeb']['uri']
			distribution "#{node['dotdeb']['distribution']}-php55"
			components ['all']
			key "http://www.dotdeb.org/dotdeb.gpg"
			action :add
		end
		apt_repository "dotdeb" do
			uri node['dotdeb']['uri']
			distribution node['dotdeb']['distribution']
			components ['all']
			key "http://www.dotdeb.org/dotdeb.gpg"
			action :add
		end
	elsif node['dotdeb']['php54']
		apt_repository "dotdeb-php54" do
			uri node['dotdeb']['uri']
			distribution "#{node['dotdeb']['distribution']}-php54"
			components ['all']
			key "http://www.dotdeb.org/dotdeb.gpg"
			action :add
		end
		apt_repository "dotdeb" do
			uri node['dotdeb']['uri']
			distribution node['dotdeb']['distribution']
			components ['all']
			key "http://www.dotdeb.org/dotdeb.gpg"
			action :add
		end
	else
		apt_repository "dotdeb" do
			uri node['dotdeb']['uri']
			distribution node['dotdeb']['distribution']
			components ['all']
			key "http://www.dotdeb.org/dotdeb.gpg"
			action :add
		end
	end

	execute "add-apt-repository" do
		command "sudo add-apt-repository ppa:ondrej/php5 && sudo apt-get update"
		action :run
	end

	execute "add-apt-repository" do
		command "sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-curl php5-mysql"
		action :run
	end	

	execute "update apt sources" do
		command "apt-get update"
		action :run
	end
end