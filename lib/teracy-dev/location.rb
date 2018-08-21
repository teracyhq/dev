require_relative 'util'

module TeracyDev
  class Location
    @@logger = Logging.logger_for(self)

    # location sync
    def self.sync(location, sync_existing = true)
      self.git_sync(location, sync_existing) if Util.exist? location['git']
    end

    private

    def self.git_sync(location, sync_existing)
      @@logger.debug("git_sync: location: #{location}; sync_existing: #{sync_existing}")

      git = location['git']
      branch = location['tag'] ||= location['branch']
      ref = location['ref']
      lookup_path = location['lookup_path']
      path = location['path']
      if File.exist? path
        if sync_existing == true
          @@logger.debug("git_sync: sync existing, location: #{location}")

          Dir.chdir(path) do
            @@logger.debug("Checking #{path}")

            `git remote remove origin`

            `git remote add origin #{git}`

            `git fetch origin`

            current_ref = `git rev-parse --verify HEAD`.strip

            if ref
              @@logger.debug("Ref detected, checking out #{ref}")

              if !current_ref.include? ref
                `git checkout #{ref}`
              end
            else
              branch ||= 'master'

              @@logger.debug("Sync with origin/#{branch}")

              remote_ref = `cat .git/refs/remotes/origin/#{branch}`.strip

              if current_ref != remote_ref
                `git checkout #{branch} && git reset --hard origin/#{branch}`
              end
            end
          end
        end
      else
        if Vagrant::Util::Which.which('git') == nil
          @@logger.error("git is not avaiable")
          abort
        end
        Dir.chdir(lookup_path) do
          @@logger.info("cd #{lookup_path} && git clone #{git}")
          system("git clone #{git}")
        end

        Dir.chdir(path) do
          @@logger.info("cd #{path} && git checkout #{branch}")
          system("git checkout #{branch}")
        end
      end
    end

    # add other types of sync protocols here when required/ implemented

  end
end