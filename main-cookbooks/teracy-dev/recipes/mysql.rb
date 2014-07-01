#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: mysql
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['mysql']['enabled']

    if !node['teracy-dev']['mysql']['password'].strip().empty?
	    # set password
	    %w(
	        server_debian_password
	        server_root_password
	        server_repl_password
	  	).each do |pwd|
	      node.default['mysql'][pwd] = node['teracy-dev']['mysql']['password']
		end
	end

    node.default['mysql']['allow_remote_root'] = true
    node.default['mysql']['bind_address'] = '0.0.0.0'

    # force apt-get update
    # https://gist.github.com/lvnilesh/4039324/#comment-984780
    execute 'compile-time-apt-get-update' do
      command 'apt-get update'
      ignore_failure true
      action :nothing
    end.run_action(:run)

    include_recipe 'mysql::server'
    include_recipe 'mysql::client'

end
