#
# Author:: Phuong <phuonglm@teracy.com>
# Cookbook Name:: dev
# Recipe:: nginx
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

if node['teracy-dev']['nginx']['enabled']
    node.override['nginx']['default_site_enabled'] = false
    node.override['nginx']['source']['use_existing_user'] = true
    node.override['nginx']['sendfile'] = 'off'
    node.override['nginx']['install_method'] = 'source'
    node.override['nginx']['init_style'] = 'upstart'

    node.override['nginx']['version'] = node['teracy-dev']['nginx']['version']
    node.override['nginx']['source']['checksum'] = node['teracy-dev']['nginx']['checksum']
    node.override['nginx']['default_root'] = node['teracy-dev']['nginx']['default_root']
    node.override['nginx']['source']['prefix'] = '/opt/nginx'
    node.override['nginx']['prefix'] = '/opt/nginx'

    node.override['nginx']['user'] = 'vagrant'
    node.override['nginx']['group'] = 'vagrant'

    nginx_version = Mixlib::ShellOut.new('/opt/nginx/sbin/nginx -v 2>/dev/stdout | grep -o "[0-9]*\.[0-9]*\.[0-9]*"').run_command.stdout.gsub("\n","")

    if nginx_version != node['teracy-dev']['nginx']['version']
        bash 'clean up previous installed nginx' do
            code <<-EOF
                killall nginx || true
                rm /opt/nginx* -rf
                rm /etc/init.d/nginx* -rf
                rm /etc/nginx/ -rf
            EOF
            user 'root'
        end
        node.from_file(run_context.resolve_attribute('nginx', 'source'))
        include_recipe 'nginx'
    end
    template "#{node['nginx']['dir']}/sites-available/default.conf" do
        source 'nginx_site.erb'
        owner 'vagrant'
        group 'vagrant'
        mode '0664'
    end
    link "#{node['nginx']['dir']}/sites-enabled/default.conf" do
      to "#{node['nginx']['dir']}/sites-available/default.conf"
    end
end
