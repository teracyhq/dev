name             'teracy-dev'
maintainer       'Teracy Inc'
maintainer_email 'hoatlevan@gmail.com'
license          'All rights reserved'
description      'Installs/Configures teracy-dev'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'python'

recipe "teracy-dev::apt", "Installs required packages for teracy's projects."
recipe "teracy-dev::workspace", "Creates workspace directory for teraciers."
recipe "teracy-dev::virtualenvwrapper", "Installs virtualenvwrapper using the python_pip resource and configure it."
recipe "teracy-dev::github", "Copies ssh keys to this virtual machine to access github's repositories."