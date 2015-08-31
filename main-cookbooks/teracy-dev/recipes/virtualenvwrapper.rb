#
# Author:: Hoat Le <hoatlevan@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: virtualenvwrapper
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

# python_pip 'virtualenvwrapper' do
#     action :install
# end

# backward compatible with teracy/dev v0.3.4 base box
directory '/home/vagrant/.virtualenvs' do
    action :delete
    not_if do ::File.exists?('/home/vagrant/.virtualenvs/premkproject') end
end

bash 'download_pyenv_virtualenvwrapper' do
    code <<-EOF
        git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git /usr/local/pyenv/plugins/pyenv-virtualenvwrapper
    EOF
    not_if 'ls -la /usr/local/pyenv/plugins/pyenv-virtualenvwrapper'
end

node['teracy-dev']['python']['versions'].each do |version|
    bash 'active_virtualenvwrapper' do
        code <<-EOF
            source /etc/profile
            pyenv virtualenvwrapper
        EOF
        environment 'PYENV_VERSION' => version
    end
end


bash 'configure_virtualenvwrapper' do
    code <<-EOF
        source /etc/profile
        echo 'export PROJECT_HOME=/vagrant/workspace/personal' >> /home/vagrant/.bash_profile
        echo 'export PATH=$HOME/.bin/:$PATH' >> /home/vagrant/.bash_profile
        echo 'pyenv virtualenvwrapper' >> /home/vagrant/.bash_profile && source /home/vagrant/.bash_profile
    EOF
    environment 'HOME'=>'/home/vagrant/'
    not_if 'grep -q pyenv /home/vagrant/.bash_profile'
    user 'vagrant'
end
