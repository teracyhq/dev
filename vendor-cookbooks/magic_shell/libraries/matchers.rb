if defined?(ChefSpec)
  def add_magic_shell_alias(name)
    ChefSpec::Matchers::ResourceMatcher.new(:magic_shell_alias, :add, name)
  end

  def remove_magic_shell_alias(name)
    ChefSpec::Matchers::ResourceMatcher.new(:magic_shell_alias, :remove, name)
  end

  def add_magic_shell_environment(name)
    ChefSpec::Matchers::ResourceMatcher.new(:magic_shell_environment, :add, name)
  end

  def remove_magic_shell_environment(name)
    ChefSpec::Matchers::ResourceMatcher.new(:magic_shell_environment, :remove, name)
  end
end
