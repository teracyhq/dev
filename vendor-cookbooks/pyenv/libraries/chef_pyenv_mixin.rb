class Chef
  module Pyenv
    module Mixin
      module ShellOut
        def shell_out!(*command_args)
          options = command_args.last.is_a?(Hash) ? command_args.pop : Hash.new
          options[:env] = shell_environment.merge(options[:env] || Hash.new)

          super(*command_args.push(options))
        end

        def shell_environment
          if pyenv_user
            { 'USER' => pyenv_user, 'HOME' => Etc.getpwnam(pyenv_user).dir }
          else
            {}
          end
        end
      end

      module ResourceString
        def to_s
          "#{@resource_name}[#{@pyenv_version || 'global'}::#{@name}] (#{@user || 'system'})"
        end
      end
    end
  end
end
