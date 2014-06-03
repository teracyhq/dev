maintainer       "Achim Rosenhagen"
maintainer_email "a.rosenhagen@ffuenf.de"
license          "Apache 2.0"
description      "installs/configures dotdeb apt repositories"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name             "dotdeb"
version          "0.0.8"

%w{ debian }.each do |os|
	supports os
end

%w{ apt }.each do |ressource|
	depends ressource
end

