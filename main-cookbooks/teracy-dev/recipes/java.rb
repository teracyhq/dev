#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: java
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['java']['enabled']
    node.default['java']['accept_license_agreement'] = true
    node.default['java']['jdk_version'] = node['teracy-dev']['java']['version']

    if node['teracy-dev']['java']['flavor'] == 'oracle'
        node.default['java']['oracle']['accept_oracle_download_terms'] = true
    end

    node.default['java']['install_flavor'] = node['teracy-dev']['java']['flavor']

    if node['teracy-dev']['java']['maven']['enabled']
		node.default['maven']['version'] = node['teracy-dev']['java']['maven']['version']
        if node['teracy-dev']['java']['maven']['version'] == '3'
            node.override['maven']['3']['version'] = '3.2.2'
            node.override['maven']['3']['url'] = 'http://www.us.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz'
            node.override['maven']['3']['checksum'] = 'cce5914cf8797671fc6e10c4e034b453d854edf711cbc664b478d0f04934cb76'
        end
		# node['maven']['m2_home'] - defaults to '/usr/local/maven/'
		# node['maven']['repositories'] - an array of maven repositories to use; must be specified as an array. 
		# node['maven']['setup_bin'] - Whether or not to put mvn on your system path, defaults to false
		# node['maven']['mavenrc']['opts'] - Value of MAVEN_OPTS environment variable exported via /etc/mavenrc template, 
		# defaults to -Dmaven.repo.local=$HOME/.m2/repository -Xmx384m -XX:MaxPermSize=192m 
	    include_recipe 'maven::default'
	end
	
    include_recipe 'java::default'
end
