if defined?(ChefSpec)
  def run_pyenv_script(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pyenv_script, :run, resource_name)
  end

  def run_pyenv_rehash(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pyenv_rehash, :run, resource_name)
  end

  def create_pyenv_global(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pyenv_global, :create, resource_name)
  end

  def install_pyenv_python(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pyenv_python, :install, resource_name)
  end

  def reinstall_pyenv_python(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pyenv_python, :reinstall, resource_name)
  end
end
