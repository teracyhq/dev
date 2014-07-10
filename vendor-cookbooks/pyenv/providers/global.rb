include Chef::Pyenv::ScriptHelpers

action :create do
  if current_global_version != new_resource.pyenv_version
    command = %{pyenv global #{new_resource.pyenv_version}}

    pyenv_script "#{command} #{which_pyenv}" do
      code        command
      user        new_resource.user       if new_resource.user
      root_path   new_resource.root_path  if new_resource.root_path

      action      :nothing
    end.run_action(:run)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{new_resource} is already set - nothing to do")
  end
end
