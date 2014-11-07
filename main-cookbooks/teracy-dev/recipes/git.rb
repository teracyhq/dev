#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: git
# Description: Configures and installs global git
#
# Copyright 2013, Teracy, Inc.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.

#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.

#     3. Neither the name of Teracy, Inc. nor the names of its contributors may be used
#        to endorse or promote products derived from this software without
#        specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

git_version = node['teracy-dev']['git']['version'].strip()

current_git_version = ''
begin
    current_git_version = Mixlib::ShellOut.new('git version').run_command.stdout.split(' ')
    current_git_version = current_git_version[current_git_version.length-1]
rescue Exception => e
    current_git_version = ''
end

if !git_version.empty?
    if current_git_version != git_version
        node.override['git']['version'] = git_version
        node.override['git']['url'] = "https://www.kernel.org/pub/software/scm/git/git-#{git_version}.tar.gz"
        node.override['git']['checksum'] = node['teracy-dev']['git']['checksum']
        include_recipe 'git::source'
    end

end

template '/home/vagrant/.gitconfig' do
    source 'gitconfig.erb'
    owner 'vagrant'
    group 'vagrant'
    mode '0664'
end

template '/home/vagrant/.gitmessage.txt' do
    source 'gitmessage.erb'
    owner 'vagrant'
    group 'vagrant'
    mode '0664'
    only_if { node['teracy-dev']['git']['commit']['template'] }
end

ruby_block 'insert_line' do
  block do
        if not node['teracy-dev']['git']['core']['filemode']
            fileName = '/home/vagrant/.bash_profile'
            if File.exist?(fileName)
                file = Chef::Util::FileEdit.new(fileName)
                file.insert_line_if_no_match(/PROMPT_COMMAND=pc/, 
            '
PROMPT_COMMAND=pc
pc () {
  [ -d .git -a ! -g .git/config ] || return
  git config core.filemode 0
  chmod +s .git/config
}')
                file.write_file
            end
        end
    end
end

ruby_block 'insert_line' do
  block do
        if not node['teracy-dev']['git']['core']['filemode']
            fileName = '/home/vagrant/.bash_profile'
            if not File.exist?(fileName)
                file = File.open(fileName, 'w')
                file.puts('
PROMPT_COMMAND=pc
pc () {
  [ -d .git -a ! -g .git/config ] || return
  git config core.filemode false
  chmod +s .git/config
}')
                file.close
            end
        end
    end
end