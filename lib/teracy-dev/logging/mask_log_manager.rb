require_relative '../util'

module TeracyDev
  module Logging
    class MaskLogManager

      @masked_values = {}
      @mask_settings = Hash.new { |hash, key| hash[key] = {} }

      def self.build_settings
        logger_default_path = File.join(TeracyDev::EXTENSION_ENTRY_PATH, 'logger.yaml')
        return unless File.exist? logger_default_path
        default_settings = Util.load_yaml_file(logger_default_path)
        build_default_settings(default_settings)

        logger_override_path = File.join(TeracyDev::EXTENSION_ENTRY_PATH, 'config_override.yaml')
        return unless File.exist? logger_override_path
        override_settings = Util.load_yaml_file(logger_override_path)
        build_override_settings(override_settings)

        add_masked_values(@mask_settings)
      end

      def self.masked(msg)
        unless @masked_values.empty?
          matcher = Regexp.union(@masked_values.keys)
          msg = msg.gsub(matcher, @masked_values)
        end
        msg
      end

      private

      def self.build_default_settings(default_settings)
        return if default_settings.empty?
        return if default_settings['logger'].nil?
        return if default_settings['logger']['mask'].nil?
        settings = default_settings['logger']['mask']
        return if settings.empty?

        settings.each do |key, value|
          next if value.nil?
          next if value.empty?

          if key == 'variables'
            build_mask_by_variables(value)
          end

          if key == 'values'
            build_mask_by_values(value)
          end
        end
      end

      def self.build_override_settings(override_settings)
        return if override_settings.empty?
        return if override_settings['variables'].nil?
        settings = override_settings['variables']
        return if settings.empty?

        build_mask_by_variables(settings)
      end

      def self.add_masked_values(mask_settings)
        unless @mask_settings.empty?
          @mask_settings.each_value do |mask_item|
            mask_item.each do |key, val|
              @masked_values[key] = val
            end
          end
        end
      end

      def self.build_mask_by_values(settings)
        settings.each do |value|
          val = value.to_s.strip
          next if val.empty?
          @mask_settings['values'][val] = '*' * val.length unless @mask_settings['values'].has_key?(val)
        end
      end

      def self.build_mask_by_variables(settings)
        settings.each do |key, val|
          next if val.nil?

          val = val.to_s.strip
          next if val.empty?

          variables_hash = {}
          matched = /\$\{(.*?)\}/.match(val)
          if matched.nil?
            variables_hash[val] = '*' * val.length
          else
            env_string = /\w+/.match(val).to_s.strip
            env_value = ENV[env_string] unless ENV[env_string].nil?
            default_value = /\:.*(\w+)/.match(val).to_s.gsub(':-','')

            if Util.exist?(env_value)
              variables_hash[env_value] = '*' * env_value.length
            else
              variables_hash[default_value] = '*' * default_value.length if Util.exist?(default_value)
            end
          end

          @mask_settings[key].replace(variables_hash)
        end
      end
    end
  end
end
