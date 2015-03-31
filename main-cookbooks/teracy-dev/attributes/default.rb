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


default['teracy-dev']['java'] = {
    'enabled' => false,
    'version' => '7',
    'flavor' => 'oracle', # one of 'openjdk', 'oracle' or 'ibm'. Default: 'oracle'
    'maven' => {
      'enabled' => false, # works only when java is enabled
      'version' => '3.2.5', # we're supporting both 2.x.x and 3.x.x
      'checksum' => '8c190264bdf591ff9f1268dc0ad940a2726f9e958e367716a09b8aaa7e74a755' # sha256
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

if node['teracy-dev']['apache']['enabled']
    override['apache']['dir'] = '/etc/apache2'
end

default['teracy-dev']['codebox'] = {
    'enabled' => false,
    'user' => 'vagrant',
    'port' => 30000,
    'sync_dir' => '/home/vagrant/workspace'
}

default['teracy-dev']['phpmyadmin'] = {
    'enabled' => false,
    'listen_port' => 9997,
    'install_dir' => '/opt/phpmyadmin'
}