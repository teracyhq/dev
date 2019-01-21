require 'set'

require_relative '../env'
require_relative 'filter'
require_relative '../util'


module TeracyDev
  module Logging
    # filter secret values out of messages from defined @masked_values
    # each mask value will have the 2nd half masked with defined mask character when filtered
    # @since v0.6.0-a5
    # @see: https://github.com/teracyhq/dev/issues/492
    class MaskFilter < Filter
      MASK_CHAR = '*'

      # build @masked_values
      # - load logger.yaml and config_override.yaml to resolve logger.mask.variables
      # - add to @masked_values from logger.mask.values
      def initialize
        super
        @masked_values = Set[] # because no duplicated values within set
        logger_conf = load_logger_conf
        return unless logger_conf_valid? logger_conf
        add_values logger_conf['logger']['mask']['values']
        resolve_variables logger_conf['logger']['mask']['variables']
      end

      def filter(msg)
        return masked(msg)
      end

      private

      # any masked_values appearing within msg will be masked its 2nd half part with MASK_CHAR
      def masked(msg)
        # puts "@masked_values.inspect: #{@masked_values.inspect}"
        @masked_values.each do |val|
          replacement = build_mask_replacement(val)
          msg = msg.sub(val, replacement)
        end
        msg
      end

      # mask 2nd half the val
      # if only 1 character => mask all
      # if the val.length is odd -> mask the less 2nd half
      def build_mask_replacement(val)
        return '' if val.nil?
        return '' if val.empty?
        return MASK_CHAR if val.length == 1
        return val.slice(0, (val.length/2.0).floor) + (MASK_CHAR * (val.length/2.0).ceil)
      end

      def logger_conf_valid?(logger_conf)
        logger_conf['logger'] && logger_conf['logger']['mask']
      end

      def resolve_variables(variables)
        return if variables.nil? or variables.empty?
        # load config_override.yaml to resolve logger.mask.variables
        # this is tightly couple with the variables processor from core
        # TODO(hoatle): maybe we should move variables processor from core to kernel
        override_variables = load_override_variables
        #puts "override_variables: #{override_variables}"
        if !override_variables.nil? and !override_variables.empty?
          # override variables existing keys with override_variables matching keys only
          variables.each do |key, val|
            #puts "key: #{key}, val: #{val}, o_val: #{override_variables[key]}"
            if !override_variables[key].nil?
              variables[key] = override_variables[key]
            end
          end
        end

        variables.each do |key, val|
          val = val.to_s
          # now resolve val to mask_value
          # refer to: https://github.com/teracyhq-incubator/teracy-dev-core/blob/develop/lib/teracy-dev-core/processors/variables.rb#L14
          match_string = /\$\{(.*):\-(.*)?\}/.match(val)

          if !match_string
            match_string = /\$\{(.*)\}/.match(val)
          end

          if match_string
            match_group = match_string.captures
            env_value = ENV[match_group[0]]

            env_default = match_group[1]

            if !env_value.nil? and !env_value.empty?
              add_values(env_value)
            else
              add_values(env_default)
            end
          else
            add_values(val)
          end
        end
      end

      def add_values(values)
        # puts "values: #{values}"
        return if values.nil? or values.empty?
        @masked_values << values
        @masked_values = @masked_values.to_a.flatten.to_set # so that we can add value as a string or array of string
      end

      def load_logger_conf
        logger_file_path = File.join(TeracyDev::Env::EXTENSION_ENTRY_PATH, 'logger.yaml')
        return {} unless File.exist? logger_file_path
        Util.load_yaml_file(logger_file_path)
      end

      def load_override_variables
        config_override_path = File.join(TeracyDev::Env::EXTENSION_ENTRY_PATH, 'config_override.yaml')
        return nil unless File.exist? config_override_path
        override_conf = Util.load_yaml_file(config_override_path)
        return {} if override_conf.nil?
        return {} if override_conf['variables'].nil?
        override_conf['variables']
      end
    end
  end
end
