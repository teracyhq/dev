#!/bin/bash

# Setup initial working environment for host machines. This initial script only serves Ubuntu.
#
# install git
# install virtualbox-4.2.10
# install vagrant 1.2.2
# TODO install rbenv and switch ruby to 1.9.3-p385 for usage later

function command_exists() {
  type "$1" &> /dev/null;
}

if ! command_exists lsb_release ; then
    echo "You're not on Ubuntu. This script is currently provided to run under Ubuntu only."
    exit
fi

is_32_bit=true
virtualbox_link=http://download.virtualbox.org/virtualbox/4.2.10/virtualbox-4.2_4.2.10-84104~Ubuntu~precise_i386.deb
vagrant_link=http://files.vagrantup.com/packages/7e400d00a3c5a0fdf2809c8b5001a035415a607b/vagrant_1.2.2_i686.deb

function determine_32_64_bit() {
    local machine=$(uname -m)
    if ! [[ $machine =~ i686 ]] ; then
        is_32_bit=false
    fi
}

determine_32_64_bit

if ! $is_32_bit ; then
    virtualbox_link=http://download.virtualbox.org/virtualbox/4.2.10/virtualbox-4.2_4.2.10-84104~Ubuntu~precise_amd64.deb
    vagrant_link=http://files.vagrantup.com/packages/7e400d00a3c5a0fdf2809c8b5001a035415a607b/vagrant_1.2.2_x86_64.deb
fi


function install_git() {
    sudo apt-get install git
}

function install_virtualbox() {
    cd /tmp
    wget $virtualbox_link
    sudo dpkg -i virtualbox-4.2_4.2.10-84104~Ubuntu~precise*
    cd -
}

function install_vagrant() {
    cd /tmp
    wget $vagrant_link
    sudo dpkg -i vagrant_1.2.2*
    cd -
}

install_git
install_virtualbox
install_vagrant

