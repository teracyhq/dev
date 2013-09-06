current_dir         = File.dirname(__FILE__)
cookbook_path       ["#{current_dir}/../main-cookbooks"]
cache_type 'BasicFile'
cache_options(:path => "#{ENV['HOME']}/.chef/checksums")
