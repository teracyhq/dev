include Chef::Pyenv::ScriptHelpers

def load_current_resource
  @python     = new_resource.version
  @root_path  = new_resource.root_path
  @user       = new_resource.user
  @environment = new_resource.environment
end

action :install do
  perform_install
end

action :reinstall do
  perform_install
end

private

def perform_install
  if python_installed?
    Chef::Log.debug("#{new_resource} is already installed - nothing to do")
  else
    install_start = Time.now

    Chef::Log.info("Building #{new_resource}, this could take a while...")

    # bypass block scoping issues
    pyenv_user    = @user
    pyenv_prefix  = @root_path
    pyenv_env     = @environment
    command       = %{pyenv install #{@python}}

    pyenv_script "#{command} #{which_pyenv}" do
      code        command
      user        pyenv_user    if pyenv_user
      root_path   pyenv_prefix  if pyenv_prefix
      environment pyenv_env     if pyenv_env

      action      :nothing
    end.run_action(:run)

    Chef::Log.debug("#{new_resource} build time was " +
      "#{(Time.now - install_start) / 60.0} minutes")

    new_resource.updated_by_last_action(true)
  end
end

def python_installed?
  if Array(new_resource.action).include?(:reinstall)
    false
  else
    ::File.directory?(::File.join(pyenv_root, 'versions', @python))
  end
end
