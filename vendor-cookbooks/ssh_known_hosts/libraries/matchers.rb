if defined?(ChefSpec)

    def append_to_ssh_known_hosts(resource)
      ChefSpec::Matchers::ResourceMatcher.new(:ssh_known_hosts_entry, :create, resource)
    end

end
