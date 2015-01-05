# Gather a list of all nodes, warning if using Chef Solo
if Chef::Config[:solo]
  fail 'ssh_known_hosts::cacher requires Chef search - Chef Solo does ' \
    'not support search!'
else
  all_host_keys = partial_search(
    :node, 'keys:*',
    :keys => {
      'hostname'        => [ 'hostname' ],
      'fqdn'            => [ 'fqdn' ],
      'ipaddress'       => [ 'ipaddress' ],
      'host_rsa_public' => [ 'keys', 'ssh', 'host_rsa_public' ],
      'host_dsa_public' => [ 'keys', 'ssh', 'host_dsa_public' ]
    }
  ).collect do |host|
    {
      'fqdn' => host['fqdn'] || host['ipaddress'] || host['hostname'],
      'key' => host['host_rsa_public'] || host['host_dsa_public']
    }
  end
  Chef::Log.debug("Partial search got: #{all_host_keys.inspect}")
end

new_data_bag_content = {
  "id" => node['ssh_known_hosts']['cacher']['data_bag_item'],
  "keys" => all_host_keys
}

Chef::Log.debug('New data bag content: ' \
  "#{new_data_bag_content.inspect}")

if Chef::DataBag.list.key?(node['ssh_known_hosts']['cacher']['data_bag'])
  # Check to see if there are actually any changes to be made (so we don't save
  # data bags unnecessarily)
  existing_data_bag_content = data_bag_item(
    node['ssh_known_hosts']['cacher']['data_bag'],
    node['ssh_known_hosts']['cacher']['data_bag_item']
  ).raw_data
  Chef::Log.debug('Existing data bag content: ' \
    "#{existing_data_bag_content.inspect}")
else
  Chef::Log.debug('Data bag ' \
    "\"#{node['ssh_known_hosts']['cacher']['data_bag']}\" not found.  " \
    'Creating.')
  new_databag = Chef::DataBag.new
  new_databag.name(node['ssh_known_hosts']['cacher']['data_bag'])
  new_databag.save
end

unless (defined? existing_data_bag_content) &&
  new_data_bag_content == existing_data_bag_content

  Chef::Log.debug('Data bag contents differ.  Saving updates.')

  host_key_db_item = Chef::DataBagItem.new
  host_key_db_item.data_bag(node['ssh_known_hosts']['cacher']['data_bag'])
  host_key_db_item.raw_data = new_data_bag_content

  host_key_db_item.save
end
