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

      git = location['git'] # maybe we'll support for protocols
      branch = location['tag'] ||= location['branch']
      ref = location['ref']
      lookup_path = location['lookup_path']
      path = location['path']
      if File.exist? path
        # only check if the extension is in the default extensions directory
        if sync_existing == true
          @@logger.debug("git_sync: sync existing, location: #{location}")

          Dir.chdir(path) do
            @@logger.debug("Checking #{path}")

            `git remote remove origin`

            `git remote add origin #{git}`

            `git fetch origin`

            if ref
              @@logger.debug("Ref detected, checking out #{ref}")

              `git checkout #{ref}`
            else
              branch ||= 'master'

              @@logger.debug("Sync with origin/#{branch}")

              `git checkout #{branch} && git reset --hard origin/#{branch}`
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

    # add other types of protocol sync here

  end
end