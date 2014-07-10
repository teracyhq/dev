include_recipe 'pyenv::system_install'

Array(node['pyenv']['pythons']).each do |python|
  if python.is_a?(Hash)
    pyenv_python python['name'] do
      environment python['environment'] if python['environment']
    end
  else
    pyenv_python python
  end
end

if node['pyenv']['global']
  pyenv_global node['pyenv']['global']
end
