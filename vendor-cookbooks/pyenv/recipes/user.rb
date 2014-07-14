include_recipe 'pyenv::user_install'

Array(node['pyenv']['user_installs']).each do |pyenv_user|
  pythons   = pyenv_user['pythons'] || node['pyenv']['user_pythons']

  pythons.each do |python|
    if python.is_a?(Hash)
      pyenv_python "#{python} (#{pyenv_user['user']})" do
        version     python
        user        pyenv_user['user']
        root_path   pyenv_user['root_path'] if pyenv_user['root_path']
        environment python['environment'] if python['environment']
      end
    else
      pyenv_python "#{python} (#{pyenv_user['user']})" do
        version     python
        user        pyenv_user['user']
        root_path   pyenv_user['root_path'] if pyenv_user['root_path']
      end
    end
  end

  pyenv_global "#{pyenv_user['global']} (#{pyenv_user['user']})" do
    pyenv_version pyenv_user['global']
    user          pyenv_user['user']
    root_path     pyenv_user['root_path'] if pyenv_user['root_path']

    only_if     { pyenv_user['global'] }
  end
end
