#
# Cookbook Name:: docker_compose
# Resource:: application
#
# Copyright (c) 2016 Sebastian Boschert, All Rights Reserved.

property :project_name, kind_of: String, name_property: true
property :compose_files, kind_of: Array, required: true
property :remove_orphans, kind_of: [TrueClass, FalseClass], default: false

default_action :up

def get_compose_params
  "-p #{project_name}" +
      ' -f ' + compose_files.join(' -f ')
end

def get_up_params
  '-d' +
    (remove_orphans ? ' --remove-orphans' : '')
end

def get_down_params
  (remove_orphans ? ' --remove-orphans' : '')
end

action :up do
  execute "running docker-compose up for project #{project_name}" do
    command "docker-compose #{get_compose_params} up #{get_up_params}"
    user 'root'
    group 'root'
  end
end


action :down do
  execute "running docker-compose down for project #{project_name}" do
    command "docker-compose #{get_compose_params} down  #{get_down_params}"
    user 'root'
    group 'root'
  end
end
