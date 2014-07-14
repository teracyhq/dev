name             'pyenv'
maintainer       'Shane da Silva'
maintainer_email 'shane@dasilva.io'
license          'Apache 2.0'
description      'Manages pyenv and its installed Python versions, also providing several LWRPs.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w[amazon centos debian fedora freebsd mac_os_x redhat scientific suse ubuntu].each do |os|
  supports os
end
