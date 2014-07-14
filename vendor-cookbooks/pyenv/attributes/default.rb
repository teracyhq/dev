# git repository containing pyenv
default['pyenv']['git_url'] = 'git://github.com/yyuu/pyenv.git'
default['pyenv']['git_ref'] = 'v0.4.0-20140516'

# upgrade action strategy
default['pyenv']['upgrade'] = 'none'

# extra system-wide tunables
default['pyenv']['root_path'] = '/usr/local/pyenv'

# a list of user hashes, each an isolated per-user pyenv installation
default['pyenv']['user_installs'] = []

# list of additional Pythons that will be installed
default['pyenv']['pythons']      = []
default['pyenv']['user_pythons'] = []

# whether to create profile.d shell script
default['pyenv']['create_profiled'] = true

case platform
when 'redhat', 'centos', 'fedora', 'amazon', 'scientific'
  node.set['pyenv']['install_pkgs'] = %w[
    bzip2 bzip2-devel
    git
    grep
    patch
    readline-devel
    sqlite sqlite-devel
    zlib-devel
    openssl-devel
  ]
  default['pyenv']['user_home_root']  = '/home'
when 'debian', 'ubuntu', 'suse'
  node.set['pyenv']['install_pkgs'] = %w[
    make
    build-essential
    libssl-dev
    zlib1g-dev
    git-core
    grep
    libbz2-dev
    libreadline-dev
    libsqlite3-dev
    wget
    curl
    llvm
  ]
  default['pyenv']['user_home_root']  = '/home'
when 'mac_os_x'
  node.set['pyenv']['install_pkgs']   = %w{git readline}
  default['pyenv']['user_home_root']  = '/Users'
when 'freebsd'
  node.set['pyenv']['install_pkgs']   = %w{git}
  default['pyenv']['user_home_root']  = '/usr/home'
end
