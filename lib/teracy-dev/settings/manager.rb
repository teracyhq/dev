require 'yaml'

require_relative '../logging'
require_relative '../util'

module TeracyDev
  module Settings
    class Manager

      @@logger = TeracyDev::Logging.logger_for('Settings:Manager')
      # build teracy-dev, organization and projects setting levels
      # then override projects => organization => teracy-dev
      def self.build_settings(lookup_dir)
        @@logger.debug("build_settings: #{lookup_dir}")
        teracy_dev_settings = build_teracy_dev_settings()
        organization_settings = build_organization_settings(lookup_dir)
        projects_settings = build_projects_settings(organization_settings)
        settings = Util.override(organization_settings, projects_settings)
        @@logger.debug("override(organization_settings, projects_settings): #{settings}")
        settings = Util.override(teracy_dev_settings, settings)
        @@logger.debug("override(teracy_dev_settings, settings): #{settings}")
        # create nodes by overrides each node with the default
        settings["nodes"].each_with_index do |node, index|
          settings["nodes"][index] = Util.override(settings['default'], node)
        end
        @@logger.debug("final: #{settings}")
        settings
      end


      def self.build_teracy_dev_settings()
        config_file_path = File.dirname(__FILE__) + '/../../../config.yaml'
        settings = load_yaml_file(config_file_path)
        @@logger.debug("build_teracy_dev_settings: #{settings}")
        settings
      end


      def self.build_organization_settings(lookup_dir)
        config_default_file_path = File.dirname(__FILE__) + '/../../../' + lookup_dir + 'config_default.yaml'
        settings = build_settings_from(config_default_file_path)
        @@logger.debug("build_organization_settings: #{settings}")
        settings
      end

      def self.build_projects_settings(organization_settings)
        # immutable
        organization_settings = Util.deep_copy(organization_settings)
        project_paths = organization_settings["vagrant"]["config_file_paths"] ||= []
        projects_settings = []
        project_paths.each do |project_path|
          project_path = File.dirname(__FILE__) + '/../../../' + project_path
          projects_settings << build_settings_from(project_path)
        end

        settings = {}
        projects_settings.reverse_each do |project_settings|
          settings = Util.override(project_settings, settings)
        end
        @@logger.debug("build_projects_settings: #{settings}")
        settings
      end

      def self.build_settings_from(default_file_path)
        @@logger.debug("build_settings_from path: '#{default_file_path}'")
        override_file_path = default_file_path.gsub(/default\.yaml$/, "override.yaml")
        default_settings = load_yaml_file(default_file_path)
        @@logger.debug("build_settings_from default_settings: #{default_settings}")
        override_settings = load_yaml_file(override_file_path)
        @@logger.debug("build_settings_from override_settings: #{override_settings}")
        settings = Util.override(default_settings, override_settings)
        @@logger.debug("build_settings_from final': #{settings}")
        settings
      end


      def self.load_yaml_file(file_path)
        if File.exists? file_path
          result = YAML.load(File.new(file_path))
          if result == false
            result = {}
          end
          result
        else
          {}
        end
      end
    end
  end
end
