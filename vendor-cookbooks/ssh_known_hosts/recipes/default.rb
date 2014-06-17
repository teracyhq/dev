#
# Cookbook Name:: ssh_known_hosts
# Recipe:: default
#
# Author:: Scott M. Likens (<scott@likens.us>)
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Seth Vargo (<sethvargo@gmail.com>)
#
# Copyright 2009, Adapp, Inc.
# Copyright 2011-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Gather a list of all nodes, warning if using Chef Solo
if Chef::Config[:solo]
  Chef::Log.warn 'ssh_known_hosts requires Chef search - Chef Solo does not support search!'

  # On Chef Solo, we still want the current node to be in the ssh_known_hosts
  hosts = [node]
else
  hosts = partial_search(:node, "keys_ssh:* NOT name:#{node.name}",
                         :keys => {
                           'hostname' => [ 'hostname' ],
                           'fqdn'     => [ 'fqdn' ],
                           'ipaddress' => [ 'ipaddress' ],
                           'host_rsa_public' => [ 'keys', 'ssh', 'host_rsa_public' ],
                           'host_dsa_public' => [ 'keys', 'ssh', 'host_dsa_public' ]
                         }
                        ).collect do |host|
                          {
                            'fqdn' => host['fqdn'] || host['ipaddress'] || host['hostname'],
                            'key' => host['host_rsa_public'] || host['host_dsa_public']
                          }
  end
end

# Add the data from the data_bag to the list of nodes.
# We need to rescue in case the data_bag doesn't exist.
begin
  hosts += data_bag('ssh_known_hosts').collect do |item|
    entry = data_bag_item('ssh_known_hosts', item)
    {
      'fqdn' => entry['fqdn'] || entry['ipaddress'] || entry['hostname'],
      'key'  => entry['rsa'] || entry['dsa']
    }
  end
rescue
  Chef::Log.info "Could not load data bag 'ssh_known_hosts'"
end

# Loop over the hosts and add 'em
hosts.each do |host|
  unless host['key'].nil?
    # The key was specified, so use it
    ssh_known_hosts_entry host['fqdn'] do
      key host['key']
    end
  else
    # No key specified, so have known_host perform a DNS lookup
    ssh_known_hosts_entry host['fqdn']
  end
end
