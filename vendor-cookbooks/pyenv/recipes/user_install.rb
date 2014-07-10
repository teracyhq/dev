include_recipe 'pyenv'

install_pyenv_pkg_prereqs

template '/etc/profile.d/pyenv.sh' do
  source  'pyenv.sh.erb'
  owner   'root'
  mode    0755
  only_if { node['pyenv']['create_profiled'] }
end

Array(node['pyenv']['user_installs']).each do |py_user|
  upgrade_strategy  = build_upgrade_strategy(py_user['upgrade'])
  git_url           = py_user['git_url'] || node['pyenv']['git_url']
  git_ref           = py_user['git_ref'] || node['pyenv']['git_ref']
  home_dir          = py_user['home'] || ::File.join(
    node['pyenv']['user_home_root'], py_user['user'])
  pyenv_prefix      = py_user['root_path'] || ::File.join(home_dir, '.pyenv')

  install_or_upgrade_pyenv  :pyenv_prefix => pyenv_prefix,
                            :home_dir => home_dir,
                            :git_url => git_url,
                            :git_ref => git_ref,
                            :upgrade_strategy => upgrade_strategy,
                            :user => py_user['user'],
                            :group => py_user['group']
end
