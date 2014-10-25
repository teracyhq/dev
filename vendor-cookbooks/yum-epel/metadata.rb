name 'yum-epel'
maintainer 'Chef'
maintainer_email 'Sean OMeara <someara@getchef.com>'
license 'Apache 2.0'
description 'Installs/Configures yum-epel'
version '0.5.1'

depends 'yum', '~> 3.0'

supports 'redhat'
supports 'centos'
supports 'scientific'
supports 'amazon'
