require "bundler/setup"

task :default => [:list]

desc "List all the tasks."
task :list do
  puts "Tasks: \n- #{(Rake::Task.tasks).join("\n- ")}"
end

desc "Checks for required dependencies."
task :check do
  environemnt_vars = [
    'OPSCODE_USER',
    'OPSCODE_ORGNAME',
    'KNIFE_CLIENT_KEY_FOLDER',
    'KNIFE_VALIDATION_KEY_FOLDER',
    'KNIFE_CHEF_SERVER',
    'KNIFE_COOKBOOK_COPYRIGHT',
    'KNIFE_COOKBOOK_LICENSE',
    'KNIFE_COOKBOOK_EMAIL',
    'KNIFE_CACHE_PATH'
  ]
  errors = []
  environemnt_vars.each do |var|
    if ENV[var].nil?
      errors.push(" - \e\[31m#Variable: #{var} not set!\e\[0m\n")
    else
      puts " - \e\[32mVariable: #{var} set to \"#{ENV[var]}\"\e\[0m\n"
    end
  end

  # client_key               "#{ENV['HOME']}/.chef/#{user}.pem"
  # validation_client_name   "#{ENV['ORGNAME']}-validator"
  # validation_key           "#{ENV['HOME']}/.chef/#{ENV['ORGNAME']}-validator.pem"
  # chef_server_url          "https://api.opscode.com/organizations/#{ENV['ORGNAME']}"


  file_list = [
    "#{ENV['KNIFE_CLIENT_KEY_FOLDER']}/#{ENV['OPSCODE_USER']}.pem",
    "#{ENV['KNIFE_VALIDATION_KEY_FOLDER']}/#{ENV['OPSCODE_ORGNAME']}-validator.pem",
  ]

    file_list.each do |file|
      if File.exist?(file)
        puts " - \e\[32mFile: \"#{file}\" found.\e\[0m\n"
      else
        errors.push(" - \e\[31mRequired file: \"#{file}\" not found!\e\[0m\n")
      end
    end

    if system("command -v virtualbox >/dev/null 2>&1")
      puts " - \e\[32mProgram: \"virtualbox\" found.\e\[0m\n"
    else
      errors.push(" - \e\[31mProgram: \"virtualbox\" not found!\e\[0m\n")
    end

    if system("command -v vagrant >/dev/null 2>&1")
      puts " - \e\[32mProgram: \"vagrant\" found.\e\[0m\n"
      %x{vagrant --version}.match(/\d+\.\d+\.\d+/) { |m|
        if Gem::Version.new(m.to_s) < Gem::Version.new('1.1.0')
          errors.push(" -- \e\[31mVagrant version \"#{m.to_s}\" is too old!\e\[0m\n")
        else
          puts " - \e\[32mVagrant \"#{m.to_s}\" works!\e\[0m\n"
        end
      }
    else
      errors.push(" - \e\[31mProgram: \"vagrant\" not found!\e\[0m\n")
    end

  unless errors.empty?
    puts "The following errors occured:\n#{errors.join()}"
  end
end

desc "Builds the package."
task :build do
  Rake::Task[:knife_test].execute
  Rake::Task[:foodcritic].execute
  Rake::Task[:chefspec].execute
end


desc "Creates a new cookbook."
task :new_cookbook, :name, :cookbook_path do |t, args|
  if args.name
    name = args.name
  else
    name = get_stdin("Enter a name for your new cookbook: ")
  end

  if args.cookbook_path
    cookbook_path = args.cookbook_path
  else
    cookbook_path = "main-cookbooks"
  end

  sh "bundle exec knife cookbook create #{name} -o #{cookbook_path}"
  sh "bundle exec knife cookbook create_specs #{name} -o #{cookbook_path}"
  minitest_path = "#{cookbook_path}/#{name}/files/default/tests/minitest"
  mkdir_p minitest_path
  File.open("#{minitest_path}/default_test.rb", 'w') do |test|
    test.puts "require 'minitest/spec'"
    test.puts ""
    test.puts "describle_recipe '#{name}::default' do"
    test.puts ""
    test.puts "end"
  end
end

desc "Runs chefspec on all the cookbooks."
task :chefspec do
  sh "bundle exec rspec main-cookbooks"
end

desc "Runs foodcritic against all the cookbooks."
task :foodcritic do
  sh "bundle exec foodcritic -I test/foodcritic/* -f any main-cookbooks"
end

desc "Runs knife cookbook test against all the cookbooks."
task :knife_test do
  sh "bundle exec knife cookbook test -a -c test/knife.rb"
end

desc "Installs Berkshelf cookbooks to vendor-cookbooks directory"
task :berks_install do
  sh "bundle exec berks vendor vendor-cookbooks"
end

desc "Uploads Berkshelf cookbooks to our chef server."
task :berks_upload do
  sh "bundle exec berks upload -c config/berks-config.json"
end


def get_stdin(message)
  print message
  STDIN.gets.chomp
end
