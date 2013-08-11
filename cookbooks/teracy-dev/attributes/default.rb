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

default['teracy-dev']['platform'] = {
    'python' => true,
    'ruby' => false
}

if node['teracy-dev']['platform']['ruby']
    # ruby installation configuration
    override[:rbenv][:install_prefix] = '/home/vagrant'
    override[:rbenv][:user]           = 'vagrant'
    override[:rbenv][:group]          = 'vagrant'
end
