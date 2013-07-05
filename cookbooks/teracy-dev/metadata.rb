name             'teracy-dev'
maintainer       'Teracy Inc'
maintainer_email 'hoatlevan@gmail.com'
license          'All rights reserved'
description      'Installs/Configures teracy-dev'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'python'
depends          'magic_shell'

recipe "teracy::alias", "Installs useful alias for teracy's project development."
recipe "teracy-dev::apt", "Installs required packages for teracy' project development."
recipe "teracy-dev::workspace", "Creates workspace directory for teraciers."
recipe "teracy-dev::virtualenvwrapper", "Installs virtualenvwrapper using the python_pip resource and configure it."
recipe "teracy-dev::ssh", "Allows to generate or use existing ssh keys."