default['teracy-dev']['workspace'] = [
    '/vagrant/workspace/readonly',
    '/vagrant/workspace/teracy',
    '/vagrant/workspace/personal'
]

default['teracy-dev']['git'] = {
    'user' => {
        'name' => 'Teracy Dev',
        'email' => 'teracy-dev@teracy.com'
    },
    'color' => true,
    'commit' => {
        'template' => true
    },
    'diff' => {
        'tool' => 'vimdiff'
    },
    'merge' => {
        'tool' => 'vimdiff'
    },
    'difftool' => {
        'prompt' => false
    }
}




default['teracy-dev']['python'] = {
    'enabled' => true,
    'pip' => {
        'global' => {
            #'index-url' => 'http://pypi.teracy.org/teracy/public/+simple/'
        }
    }
}

default['teracy-dev']['ruby'] = {
    'enabled' => false
}

default['teracy-dev']['gettext'] = false

if node['teracy-dev']['python']['enabled']
    override['python']['setuptools_script_url'] = 'https://bitbucket.org/pypa/setuptools/raw/1.0/ez_setup.py'
end

if node['teracy-dev']['ruby']['enabled']
    # ruby installation configuration
    override['rbenv']['install_prefix'] = '/home/vagrant'
    override['rbenv']['user']           = 'vagrant'
    override['rbenv']['group']          = 'vagrant'
end
