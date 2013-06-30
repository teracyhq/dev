current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "hoatle"
client_key               "#{current_dir}/hoatle.pem"
validation_client_name   "teracy-validator"
validation_key           "#{current_dir}/teracy-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/teracy"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
