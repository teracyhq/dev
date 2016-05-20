provides :resource
resource_name :resource

action :create do
  log "resource" do
    notifies :write, "log[recipe]"
  end
end
