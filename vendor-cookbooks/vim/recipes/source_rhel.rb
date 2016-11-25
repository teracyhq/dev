# vim looks for xsubpp in wrong location RHEL 7+ and Fedora

link '/usr/share/perl5/ExtUtils/xsubpp' do
  to '/usr/bin/xsubpp'
  only_if { ::File.exist?('/usr/bin/xsubpp') } # if package node attributes don't include perl this won't be here
end if node['platform_version'].to_i >= 7

package 'bzip2' if node['platform_version'].to_i >= 7
