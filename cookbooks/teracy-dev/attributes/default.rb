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
    }
}