require_relative 'configurator'

module TeracyDev
  module Config
    # see: https://www.vagrantup.com/docs/vagrantfile/vagrant_settings.html
    class Vgrant < Configurator

      def configure(settings, config, type:)
        case type
        when 'common'
          # ignore
        when 'node'
          vagrant_settings = settings['vagrant']
        end
        vagrant_settings ||= {}
        @logger.debug("configure #{type}: #{vagrant_settings}")

        config.vagrant.set_options(vagrant_settings)
      end
    end
  end
end
