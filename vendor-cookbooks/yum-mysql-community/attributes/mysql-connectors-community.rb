default['yum']['mysql-connectors-community']['repositoryid'] = 'mysql-connectors-community'
default['yum']['mysql-connectors-community']['gpgkey'] = 'https://raw.githubusercontent.com/someara/yum-mysql-community/master/files/mysql_pubkey.asc'
default['yum']['mysql-connectors-community']['description'] = 'MySQL Connectors Community'
default['yum']['mysql-connectors-community']['failovermethod'] = 'priority'
default['yum']['mysql-connectors-community']['gpgcheck'] = true
default['yum']['mysql-connectors-community']['enabled'] = true

case node['platform_family']
when 'rhel'
  case node['platform']
  when 'amazon'
    case node['platform_version'].to_i
    when 2013
      default['yum']['mysql-connectors-community']['baseurl'] = 'http://repo.mysql.com/yum/mysql-connectors-community/el/6/$basearch/'
    when 2014
      default['yum']['mysql-connectors-community']['baseurl'] = 'http://repo.mysql.com/yum/mysql-connectors-community/el/6/$basearch/'
    end
  else # other rhel
    default['yum']['mysql-connectors-community']['baseurl'] = 'http://repo.mysql.com/yum/mysql-connectors-community/el/$releasever/$basearch/'
  end
when 'fedora'
  default['yum']['mysql-connectors-community']['baseurl'] = 'http://repo.mysql.com/yum/mysql-connectors-community/fc/$releasever/$basearch/'
end
