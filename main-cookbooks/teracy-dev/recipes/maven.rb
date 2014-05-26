#
# Author:: Vinh Tran <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: maven
# Description: Installs Maven 
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['maven']['enabled']

	node.default['maven']['version'] = node['teracy-dev']['maven']['version']
	# node['maven']['m2_home'] - defaults to '/usr/local/maven/'
	# node['maven']['repositories'] - an array of maven repositories to use; must be specified as an array. 
	# node['maven']['setup_bin'] - Whether or not to put mvn on your system path, defaults to false
	# node['maven']['mavenrc']['opts'] - Value of MAVEN_OPTS environment variable exported via /etc/mavenrc template, 
	# defaults to -Dmaven.repo.local=$HOME/.m2/repository -Xmx384m -XX:MaxPermSize=192m 

    include_recipe 'maven::default'

end
