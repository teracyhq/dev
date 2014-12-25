if defined?(ChefSpec)

  def config_iis_config(command)
    ChefSpec::Matchers::ResourceMatcher.new(:iis_config, :config, command)
  end

  [:config, :add, :delete].each do |action|
    self.class.send(:define_method, "#{action}_iis_app", proc  do |app_name|
      ChefSpec::Matchers::ResourceMatcher.new(:iis_app, action, app_name)
    end
    )
  end

  [:add, :delete].each do |action|
    self.class.send(:define_method, "#{action}_iis_module", proc do |module_name|
      ChefSpec::Matchers::ResourceMatcher.new(:iis_module, action, module_name)
    end
    )
  end

  [:add, :config, :delete, :start, :stop, :restart, :recycle].each do |action|
    self.class.send(:define_method, "#{action}_iis_pool", proc do |pool_name|
      ChefSpec::Matchers::ResourceMatcher.new(:iis_pool, action, pool_name)
    end
    )
  end

  [:add, :delete, :start, :stop, :restart, :config].each do |action|
    self.class.send(:define_method, "#{action}_iis_site", proc do |site_name|
      ChefSpec::Matchers::ResourceMatcher.new(:iis_site, action, site_name)
    end
    )
  end

  ChefSpec::Runner.define_runner_method :iis_app
  ChefSpec::Runner.define_runner_method :iis_config
  ChefSpec::Runner.define_runner_method :iis_module
  ChefSpec::Runner.define_runner_method :iis_pool
  ChefSpec::Runner.define_runner_method :iis_site
end
