#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: dev
# Recipe:: mysql
#
# Copyright 2013 - current, Teracy, Inc.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.

#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.

#     3. Neither the name of Teracy, Inc. nor the names of its contributors may be used
#        to endorse or promote products derived from this software without
#        specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
        not_if { mysql_installed? }
    end.run_action(:run)

    mysql_service 'default' do
      version node['teracy-dev']['mysql']['version']
      bind_address '0.0.0.0'
      port '3306'
      initial_root_password node['teracy-dev']['mysql']['password']
      action [:create, :start]
    end

    bash 'update mysql_socket_path for mysql cli command' do
      code <<-EOF
        sed -i 's/^socket\\s*=\\s*.*$/socket = \\/run\\/mysql-default\\/mysqld.sock/' /etc/mysql/debian.cnf
        sed -i 's/^user\\s*=\\s*.*$/user = root'/ /etc/mysql/debian.cnf
        sed -i 's/^password\\s*=\\s*.*$/password = #{node['teracy-dev']['mysql']['password']}/' /etc/mysql/debian.cnf
        cp /etc/mysql/debian.cnf /etc/mysql/my.cnf
        chmod 644 /etc/mysql/my.cnf
      EOF
      user 'root'
    end
end
