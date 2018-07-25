require_relative 'configurator'

module TeracyDev
  module Config
    # see: https://www.vagrantup.com/docs/vagrantfile/winssh_settings.html
    class WinSSH < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          # ignore
        when 'node'
          winssh_settings = settings['winssh']
        end
        winssh_settings ||= {}
        @logger.debug("configure #{type}: #{winssh_settings}")

        config.winssh.set_options(winssh_settings)
      end
    end
  end
end
