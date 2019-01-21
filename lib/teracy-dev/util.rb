require_relative 'logging'
require 'yaml'

module TeracyDev
  class Util
    @@logger = TeracyDev::Logging.logger_for(self)
    @@deprecated_messages = []

    # check if a value exists (not nil and not empty if is a string)
    def self.exist?(value)
      exist = false
      if !value.nil?
        if value.instance_of? String
          exist = !value.empty?
        else
          exist = true
        end
      end
      exist
    end

    # convert a value (case insensitive) to boolean value
    # true, "true", "t", "yes", "y", "1" => true
    # false, "false", "f", "no", "n", "0" => false
    # otherwise, error raised
    def self.boolean(value)
      return true if value == true || value.to_s.downcase =~ (/(true|t|yes|y|1)$/i)
      return false if value == false || value.to_s.empty? || value.to_s.downcase =~ (/(false|f|no|n|0)$/i)
      raise ArgumentError.new("invalid value for boolean: #{value}")
    end


    # convert a value (case insentitive) to a boolen value
    # true, "true", "t", "yes", "y", "1" => true
    # othwerwise, false
    #
    # @since v0.6.0-a5
    def self.true?(value)
      begin
        return self.boolean(value)
      rescue
        return false
      end
    end

    # sort by multiple fields and multilple directions for different data types
    #
    # data structure of items: hash in array [ {} ]
    # this will return a sorted items by the keys with their specified ascending or descending order
    #
    # @since v0.6.0-a5
    # @see https://stackoverflow.com/questions/28234803/ruby-sort-by-multiple-fields-and-multilple-directions-for-different-data-types
    def self.multi_sort(items, order)
      direction_multiplier = { asc: 1, desc: -1 }
      items.sort do |this, that|
        order.reduce(0) do |diff, order|
          next diff if diff != 0 # this and that have differed at an earlier order entry
          key, direction = order
          # deal with nil cases
          next  0 if this[key].nil? && that[key].nil?
          next  1 if this[key].nil?
          next -1 if that[key].nil?
          # do the actual comparison
          comparison = this[key] <=> that[key]
          next comparison * direction_multiplier[direction]
        end
      end
    end

    # find the extension lookup_path by its name from the provided settings
    def self.extension_lookup_path(settings, extension_name)
      @@logger.debug("settings: #{settings}")
      extensions = settings['teracy-dev']['extensions'] ||= []

      extensions.each do |ext|
        manifest = Extension::Manager.manifest(ext)
        if manifest['name'] == extension_name
          return ext['path']['lookup'] || TeracyDev::DEFAULT_EXTENSION_LOOKUP_PATH
        end
      end
      # extension_name not found
      return nil
    end

    def self.load_yaml_file(file_path)
      if File.exist? file_path
        # TODO: exception handling
        result = YAML.load_file(file_path)
        if result == false
          @@logger.debug("#{file_path} is empty")
          result = {}
        end
        result
      else
        @@logger.debug("#{file_path} does not exist")
        {}
      end
    end

    def self.build_settings_from(default_file_path)
      @@logger.debug("default_file_path: #{default_file_path}")
      override_file_path = default_file_path.gsub(/default\.yaml$/, "override.yaml")
      default_settings = load_yaml_file(default_file_path)
      @@logger.debug("default_settings: #{default_settings}")
      override_settings = load_yaml_file(override_file_path)
      @@logger.debug("override_settings: #{override_settings}")
      settings = Util.override(default_settings, override_settings)
      @@logger.debug("final: #{settings}")
      settings
    end

    # thanks to https://gist.github.com/Integralist/9503099
    def self.symbolize(obj)
      return obj.reduce({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = symbolize(v) }
      end if obj.is_a? Hash

      return obj.reduce([]) do |memo, v|
        memo << symbolize(v); memo
      end if obj.is_a? Array

      obj
    end

    # file_path must be absolute path
    def self.load_file_path(file_path)
      @@logger.debug("load_file_path: #{file_path}")
      begin
        load file_path
      rescue Exception => msg
        @@logger.error(msg)
      end
    end

    # deep_copy an object to make it immutable
    # useful for hash object manipulation
    def self.deep_copy(o)
      Marshal.load(Marshal.dump(o))
    end


    def self.require_version_valid?(version, requirements)
      @@logger.debug("version: #{version.strip}; requirements: #{requirements.strip}")
      requirements = requirements.split(',')
      req = Gem::Requirement.new(*requirements)
      req.satisfied_by?(Gem::Version.new(version))
    end

    # teracy-dev hash override algorithm
    # override the originalHash object with the sourceHash object
    # this method is immutable
    # this method is the combination of hash merge with special treatment to array value:
    # "_id" is required for every object within the array.
    # By introducing "_id" and "_op" meta key, we can override the configuration by its "_id" with its "_op" option ("a" - append, "o" - override, "r" - replace, "d" - delete).
    # _id exist => _op="o" by default. _op could be one of [o, r, d]
    # _id does not exist => _op="a" by default and only this value can be used.
    # _op="a": adding to the end of the array by default. To specify the index to append after, use "_idx" key with the right index (see Array.insert(index, value) Ruby API to use the right index value)
    # We also support force override the array key with: "r" ("r" - replace) to completely replace the array key, this is useful when we want to replace the array completely
    # We also support update by adding more array elements by the key with "_ua_" prefix, this is useful for array objects without "_id_" key.
    # for example:
    # "_r_synced_folders": [] # This will replace default "synced_folders" with an empty array "[]".
    # "_ua_aliases": ["dev.teracy.com"] # This will update "aliases" by appending specified items.
    # "_" is reserved for teracy-dev to override the default config.
    # This is applied for objects within array only, for JSON object, just use its key to override.
    # see: https://github.com/teracyhq/dev/issues/239
    # TODO: refactor this into a new module (merger.rb), currently, maintaining this is a nightmare
    def self.override(originHash, sourceHash)
      # immutable
      originHash = originHash.clone
      sourceHash = sourceHash.clone

      sourceHash.each do |key, value|
        next if value.nil?

        replaced_key = key.to_s.sub(/_u?[ra]_/, '')

        if !originHash.has_key?(replaced_key)
          if value.class.name == 'Hash'
            originHash[key] = {}
          elsif value.class.name == 'Array'
            originHash[replaced_key] = []
          end
        end

        # replace
        if value.class.name == 'Array'
          if (key.start_with?('_r_') || key.start_with?('_a_') || key.start_with?('_ua_')) && originHash.has_key?(key)
            originHash[replaced_key] = originHash[key].clone
            originHash.delete(key)
          end

          if (key.start_with?('_r_') || key.start_with?('_a_') || key.start_with?('_ua_'))  && !originHash.has_key?(replaced_key)
            originHash[replaced_key] = []
            key = replaced_key
          else
            if key.start_with?('_r_')
              originHash[replaced_key] = []
              key = replaced_key
            elsif key.start_with?('_a_')
              value = originHash[replaced_key].concat(sourceHash[key])
              key = replaced_key
            elsif key.start_with?('_ua_')
              value = (originHash[replaced_key].concat(sourceHash[key])).uniq
              key = replaced_key
            end
          end
        end

        if value.class.name == 'Hash'
          originHash[key] = override(originHash[key], sourceHash[key])
        elsif value.class.name == 'Array'
          originHash_value = originHash[key].clone || []
          if value[0].class.name != 'Hash'
            originHash_value = value
          else
            value.map! do |val|
              if val.class.name == 'Hash'
                id_existing = false
                originHash[key] ||= []
                originHash[key].each do |val1|

                  if val1['_id_deprecated'] != nil && val['_id'] == val1['_id_deprecated']
                    message = "The _id: '#{val1['_id_deprecated']}' is deprecated, use the _id: '#{val1['_id']}' instead for #{val}"
                    unless @@deprecated_messages.include?(message)
                      @@logger.warn(message)
                      @@deprecated_messages << message
                    end

                    # val['_id'] should be updated to use val1['_id'] instead
                    val['_id'] = val1['_id']
                  end

                  if val1['_id'] == val['_id']
                    id_existing = true
                    break
                  end
                end

                if id_existing == false
                  if !val['_op'].nil? and val['_op'] != 'a'
                    # warnings
                    @@logger.warn("_op = #{val['_op']} is invalid for non-existing id: #{val}")
                  end
                  operator = 'a'
                elsif val['_op'].nil?
                  operator = 'o'
                else
                  operator = val['_op']
                end

                if operator == 'a'
                  if val['_idx'].nil?
                    originHash_value.push(override({}, val))
                  else
                    originHash_value.insert(val['_idx'], override({}, val))
                  end
                elsif operator == 'o'
                  originHash_value.map! do |val2|
                    if val2['_id'] == val['_id']
                      val2 = override(val2, val)
                    end
                    val2
                  end
                elsif operator == 'r'
                  originHash_value.map! do |val3|
                    if val3['_id'] == val['_id']
                      val3 = override({}, val)
                    end
                    val3
                  end
                elsif operator == 'd'
                  originHash_value.delete_if {|val4| val4['_id'] == val['_id'] }
                end
              else
                originHash_value = value
              end
              val
            end
          end
          originHash[key] = originHash_value

        else
          # merge key here
          originHash[key] = value
        end
      end
      return originHash
    end
  end
end
