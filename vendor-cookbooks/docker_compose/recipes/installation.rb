#
# Cookbook Name:: docker_compose
# Recipe:: installation
#
# Copyright (c) 2016 Sebastian Boschert, All Rights Reserved.

def get_install_url
  release = node['docker_compose']['release']
  kernel_name = node['kernel']['name']
  machine_hw_name = node['kernel']['machine']
  "https://github.com/docker/compose/releases/download/#{release}/docker-compose-#{kernel_name}-#{machine_hw_name}"
end

command_path = node['docker_compose']['command_path']
install_url = get_install_url

package 'curl' do
  action :install
end

directory '/etc/docker-compose' do
  action :create
  owner 'root'
  group 'docker'
  mode '0750'
end

execute 'install docker-compose' do
  action :run
  command "curl -sSL #{install_url} > #{command_path} && chmod +x #{command_path}"
  creates command_path
  user 'root'
  group 'docker'
  umask '0027'
end
