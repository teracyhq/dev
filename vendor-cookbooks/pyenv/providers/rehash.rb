include Chef::Pyenv::ScriptHelpers

action :run do
  command = 'pyenv rehash'

  pyenv_script "#{command} #{which_pyenv}" do
    code        command
    user        new_resource.user       if new_resource.user
    root_path   new_resource.root_path  if new_resource.root_path

    action      :nothing
  end.run_action(:run)

  new_resource.updated_by_last_action(true)
end
