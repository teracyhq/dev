template "#{node['nginx']['dir']}/sites-enabled/phpmyadmin.conf" do
  source "nginx.conf.erb"
  variables(
    :docroot          => node['phpmyadmin']['home'],
    :server_name      => node['phpmyadmin']['server_name'],
  )
  action :create
end
