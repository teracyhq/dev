#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: ssh
#
# Copyright 2013, Teracy, Inc.
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

if node['teracy-dev']['ssh']

    cookbook_file '/home/vagrant/.ssh/id_rsa' do
        owner 'vagrant'
        source 'id_rsa'
        mode 0600
        action :create_if_missing
        only_if '[ -f /home/vagrant/.teracy/ssh_check ]'
        ignore_failure true
    end

    cookbook_file '/home/vagrant/.ssh/id_rsa.pub' do
        owner 'vagrant'
        source 'id_rsa.pub'
        mode 0600
        action :create_if_missing
        only_if '[ -f /home/vagrant/.teracy/ssh_check ]'
        ignore_failure true
    end

    directory '/home/vagrant/.teracy' do
        owner 'vagrant'
        group 'vagrant'
        mode 00755
        action :create
    end

    file '/home/vagrant/.teracy/ssh_check' do
        owner 'vagrant'
        mode 0600
        action :create_if_missing
    end

    cookbook_file '/home/vagrant/.teracy/ssh-check.sh' do
        owner 'vagrant'
        source 'ssh-check.sh'
        mode 00755
        action :create_if_missing
    end

    bash 'add_source_ssh-check' do
        code <<-EOF
            echo 'source /home/vagrant/.teracy/ssh-check.sh' >> /home/vagrant/.profile
        EOF
        not_if 'grep -q ssh-check.sh /home/vagrant/.profile'
    end

end

