include_recipe 'pyenv'

upgrade_strategy  = build_upgrade_strategy(node['pyenv']['upgrade'])
git_url           = node['pyenv']['git_url']
git_ref           = node['pyenv']['git_ref']
pyenv_prefix      = node['pyenv']['root_path']

install_pyenv_pkg_prereqs

directory '/etc/profile.d' do
  owner   'root'
  mode    0755
end

template '/etc/profile.d/pyenv.sh' do
  source  'pyenv.sh.erb'
  owner   'root'
  mode    0755
end

install_or_upgrade_pyenv  :pyenv_prefix => pyenv_prefix,
                          :git_url => git_url,
                          :git_ref => git_ref,
                          :upgrade_strategy => upgrade_strategy
