include Chef::Pyenv::ScriptHelpers

action :run do
  script_code         = build_script_code
  script_environment  = build_script_environment

  script new_resource.name do
    interpreter   'bash'
    code          script_code
    user          new_resource.user     if new_resource.user
    creates       new_resource.creates  if new_resource.creates
    cwd           new_resource.cwd      if new_resource.cwd
    group         new_resource.group    if new_resource.group
    path          new_resource.path     if new_resource.path
    returns       new_resource.returns  if new_resource.returns
    timeout       new_resource.timeout  if new_resource.timeout
    umask         new_resource.umask    if new_resource.umask
    environment(script_environment)
  end

  new_resource.updated_by_last_action(true)
end

private

def build_script_code
  script = []
  script << %{export PYENV_ROOT="#{pyenv_root}"}
  script << %{export PATH="${PYENV_ROOT}/bin:$PATH"}
  script << %{eval "$(pyenv init -)"}
  if new_resource.pyenv_version
    script << %{export PYENV_VERSION="#{new_resource.pyenv_version}"}
  end
  script << new_resource.code
  script.join("\n")
end

def build_script_environment
  script_env = { 'PYENV_ROOT' => pyenv_root }
  if new_resource.environment
    script_env.merge!(new_resource.environment)
  end
  if new_resource.user
    script_env.merge!({ 'USER' => new_resource.user,'HOME' => user_home })
  end

  script_env
end
