require_relative '../logging'

module TeracyDev
  module Location
    class GitSynch

      def initialize
        @logger = TeracyDev::Logging.logger_for(self.class.name)
      end
      # return true if sync action is carried out, otherwise, return false
      def sync(location, sync_existing)
        @logger.debug("location: #{location}; sync_existing: #{sync_existing}")
        updated = false
        return updated if ! Util.exist? location['git']

        git = location['git']
        branch = location['branch'] ||= 'master'
        tag = location['tag']
        ref = location['ref']
        lookup_path = location['lookup_path']
        path = location['path']
        dir = location['dir']

        if File.exist? path
          if sync_existing == true
            @logger.debug("sync existing, location: #{location}")

            Dir.chdir(path) do
              @logger.debug("Checking #{path}")

              current_git = `git remote get-url origin`.strip

              current_ref = `git rev-parse --verify HEAD`.strip

              if current_git != git
                `git remote remove origin`

                `git remote add origin #{git}`
                updated = true
              end

              if git_stage_has_untracked_changes?
                @logger.warn("`#{path}` has untracked changes, auto update is aborted!\n #{`git status`}")

                return false
              end

              if ref
                updated = check_ref(current_ref, ref)
              elsif tag
                updated = check_tag(current_ref, tag)
              else
                branch ||= 'master'

                updated = check_branch(current_ref, branch)
              end
            end
          end
        else
          if Vagrant::Util::Which.which('git') == nil
            @logger.error("git is not avaiable")
            abort
          end
          Dir.chdir(lookup_path) do
            @logger.info("cd #{lookup_path} && git clone #{git} #{dir}")
            system("git clone #{git} #{dir}")
          end

          Dir.chdir(path) do
            @logger.info("cd #{path} && git checkout #{branch}")
            system("git checkout #{branch}")
          end
          updated = true
        end
        updated
      end

      private

      def check_ref(current_ref, ref_string)
        @logger.debug("ref detected, checking out #{ref_string}")
        updated = false
        if !current_ref.start_with? ref_string
          `git fetch origin`

          `git checkout #{ref_string}`
          updated = true
        end
        updated
      end

      def check_tag(current_ref, desired_tag)
        @logger.debug("Sync with tags/#{desired_tag}")

        updated = false

        cmd = "git log #{desired_tag} -1 --pretty=%H"

        tag_ref = `#{cmd}`.strip

        if !$?.success?
          # fetch origin if tag is not present
          `git fetch origin`

          # re-check
          tag_ref = `#{cmd}`.strip

          if !$?.success?
            # tag not found
            @logger.warn("tag not found: #{desired_tag}")

            return updated
          end
        end

        @logger.debug("current_ref: #{current_ref} - tag_ref: #{tag_ref}")

        if current_ref != tag_ref
          `git checkout tags/#{desired_tag}`

          updated = true
        end

        updated
      end

      def check_branch(current_ref, desired_branch)
        @logger.debug("Sync with origin/#{desired_branch}")
        updated = false
        current_branch = `git rev-parse --abbrev-ref HEAD`.strip

        # branch master/develop are always get update
        # 
        # other branch is only get update once
        if ['master', 'develop'].include? desired_branch
          `git fetch origin`
        # only fetch if it is valid branch and not other (tags, ref, ...)
        elsif desired_branch != current_branch and current_branch != 'HEAD'
          `git fetch origin`
        end

        @logger.debug("current_branch: #{current_branch} - desired_branch: #{desired_branch}")

        quoted_branch = Regexp.quote(desired_branch).gsub("/", '\/')

        remote_ref = `git show-ref --head | sed -n 's/ .*\\(refs\\/remotes\\/origin\\/#{quoted_branch}\\).*//p'`.strip

        # remote origin ref is not exist mean remote origin branch is not exist
        # if found no such remote branch, switch to found as tag
        return check_tag(current_ref, desired_branch) if !Util.exist? remote_ref

        @logger.debug("current_ref: #{current_ref} - remote_ref: #{remote_ref}")

        if current_ref != remote_ref
          `git checkout #{desired_branch}`

          if !$?.success?
            # create new local branch if it is not present
            @logger.debug("No such branch! Creating one.")

            `git checkout -b #{desired_branch}`
          end

          `git reset --hard origin/#{desired_branch}`
          updated = true
        end
        updated
      end

      def git_stage_has_untracked_changes?()
        !Util.exist? `git status | grep 'nothing to commit, working tree clean'`.strip
      end

    end
  end
end
