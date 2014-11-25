#
# Author:: Phuong <phuonglm@teracy.com>
# Cookbook Name:: dev
# Recipe:: nginx
#
# Copyright 2014, Teracy, Inc.
#

if node['teracy-dev']['apache']['enabled']
    node.default['apache']['default_site_enabled'] = false
    node.default['apache']['docroot_dir'] = node['teracy-dev']['apache']['default_root']
    node.default['apache']['listen_ports'] = [node['teracy-dev']['apache']['listen_port']]
    node.default['apache']['user'] = 'vagrant'
    node.default['apache']['group'] = 'vagrant'
    include_recipe 'apache2'

    file "#{node['apache']['dir']}/sites-available/default.conf" do
      action :delete
    end

    file "#{node['apache']['dir']}/sites-available/default-ssl" do
      action :delete
    end

    link "#{node['apache']['dir']}/sites-enabled/000-default" do
      action :delete
    end

    template "#{node['apache']['dir']}/sites-available/default.conf" do
        source 'apache_site.erb'
        owner 'vagrant'
        group 'vagrant'
        mode '0664'
    end
    link "#{node['apache']['dir']}/sites-enabled/default.conf" do
      to "#{node['apache']['dir']}/sites-available/default.conf"
    end

    directory '/var/lock/apache2' do
        owner 'vagrant'
        group 'vagrant'
        mode '0755'
    end

    apache_module 'php5' do
      enable false
    end
    apache_module 'vhost_alias' do
      enable true
    end

    service 'apache2' do
      action :restart
    end
end
