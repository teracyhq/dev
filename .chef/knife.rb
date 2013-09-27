# Configurable Variables (Change these to not depend on environment variables!)
my_orgname              = ENV['OPSCODE_ORGNAME']
my_chef_server_url      = ENV['KNIFE_CHEF_SERVER']
my_cookbook_copyright   = ENV['KNIFE_COOKBOOK_COPYRIGHT']
my_cookbook_license     = ENV['KNIFE_COOKBOOK_LICENSE']
my_cookbook_email       = ENV['KNIFE_COOKBOOK_EMAIL']


# Configuration
current_dir             = File.dirname(__FILE__)
node_name               ENV['OPSCODE_USER']
client_key              "#{ENV['KNIFE_CLIENT_KEY_FOLDER']}/#{ENV['OPSCODE_USER']}.pem"
validation_client_name  "#{my_orgname}-validator"
validation_key          "#{ENV['KNIFE_VALIDATION_KEY_FOLDER']}/#{my_orgname}-validator.pem"
chef_server_url         my_chef_server_url

# Caching
cache_type              'BasicFile'
cache_options( :path => ENV['KNIFE_CACHE_PATH'] )

# Logging
log_level               :info
log_location            STDOUT

# Cookbooks
cookbook_path           ["#{current_dir}/../main-cookbooks"]
cookbook_copyright      my_cookbook_copyright
cookbook_license        my_cookbook_license
cookbook_email          my_cookbook_email
