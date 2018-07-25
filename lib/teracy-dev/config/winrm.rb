require_relative 'configurator'

module TeracyDev
  module Config
    # see: https://www.vagrantup.com/docs/vagrantfile/winrm_settings.html
    class WinRM < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          # ignore
        when 'node'
          winrm_settings = settings['winrm']
        end
        winrm_settings ||= {}
        @logger.debug("configure #{type}: #{winrm_settings}")

        config.winrm.set_options(winrm_settings)
      end
    end
  end
end
