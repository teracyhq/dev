name             'teracy-dev'
maintainer       'Teracy Inc'
maintainer_email 'hoatlevan@gmail.com'
license          'All rights reserved'
description      'Installs/Configures teracy-dev'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'magic_shell'
depends          'python'

recipe "teracy-dev::virtualenvwrapper", "Installs virtualenvwrapper using the python_pip resource and configure it."