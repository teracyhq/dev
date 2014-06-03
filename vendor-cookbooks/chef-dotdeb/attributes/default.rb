node.default['dotdeb']['uri'] = "http://packages.dotdeb.org"
node.default['dotdeb']['distribution'] = node['lsb']['codename']

#(Optional) if you want to install PHP 5.4, set the following variable to true:
node.default['dotdeb']['php54'] = true # for debian 6 (squeeze)

#(Optional) if you want to install PHP 5.5, set the following variable to true:
node.default['dotdeb']['php55'] = false # for debian 7 (wheezy)