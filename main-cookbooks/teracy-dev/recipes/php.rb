#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: php
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['php']['enabled']    	    
    
	include_recipe "php"
	include_recipe "php::package"
	include_recipe "php::source"
	include_recipe "php::module_curl"
	include_recipe "php::module_fpdf"
	include_recipe "php::module_gd"
	include_recipe "php::module_ldap"
	include_recipe "php::module_memcache"

end