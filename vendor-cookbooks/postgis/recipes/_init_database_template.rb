execute 'create_postgis_template' do
  not_if "psql -qAt --list | grep -q '^#{node['postgis']['template_name']}\|'", :user => 'postgres'
  user 'postgres'
  command <<CMD
createdb -E UTF8 --locale=#{node['postgis']['locale']} #{node['postgis']['template_name']} -T template0
CMD
  action :run
end

if node['platform'] == 'ubuntu' && node['platform_version'].to_f <= 12.04
  execute 'create_postgis_extension' do
    user 'postgres'
    command <<CMD
(psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/postgis-2.0/postgis.sql) &&
(psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/postgis-2.0/spatial_ref_sys.sql)
CMD
    action :run
  end
else
  execute 'create_postgis_extension' do
    user 'postgres'
    command <<CMD
(psql -d #{node['postgis']['template_name']} -c 'create extension if not exists postgis') &&
(psql -d #{node['postgis']['template_name']} -c 'create extension if not exists postgis_topology')
CMD
    action :run
  end
end
