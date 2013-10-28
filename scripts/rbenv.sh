#!/bin/bash

# install rbenv and switch ruby to 1.9.3-p194
# kudos to https://learnchef.opscode.com/quickstart/workstation-setup/#linux for manual installation

# How to install:
# $ cd /tmp && wget https://raw.github.com/teracy-official/dev/master/scripts/rbenv.sh && chmod +x rbenv.sh && . ./rbenv.sh && cd ~
# TODO(phuonglm): improve this: non-root user? this was validated on dev VM only, what's about clean Ubuntu instance?
function install_support_packages() {
    sudo apt-get install build-essential git
}

function install_rbenv() {
    #clone rbenv from official git repository and add it to your path
    cd ~
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> .profile
    echo 'eval "$(rbenv init -)"' >> .profile
    source ~/.profile
}

function install_ruby_build() {
    cd /tmp
    git clone git://github.com/sstephenson/ruby-build.git
    cd ruby-build
    sudo ./install.sh
}

function install_ruby() {
    rbenv rehash
    rbenv install 1.9.3-p194
    rbenv shell 1.9.3-p194
    rbenv global 1.9.3-p194
}

sudo apt-get update
install_support_packages
install_rbenv
install_ruby_build
install_ruby
