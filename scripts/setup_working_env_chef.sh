#!/bin/bash

# Setup initial working environment for host machines. This initial script only serves Ubuntu.
#
# install git
# install virtualbox-4.3.4
# install vagrant 1.7.2

function command_exists() {
    type "$1" &> /dev/null;
}

distributor_id=`command_exists lsb_release && lsb_release -i`
code_name=$(lsb_release -a | grep Codename | awk '{print $2}')
vagrant_version="1.7.2"

if [[ "$distributor_id" != *Ubuntu* ]]; then
    echo "You're not on Ubuntu. This script is currently provided to run under Ubuntu only."
    exit 1
fi

if [ "$code_name" == "trusty" ] || [ "$code_name" == "saucy" ] || [ "$code_name" == "utopic" ]; then
    vbox_download_code_name="raring"
fi

is_32_bit=true
virtualbox_link="http://download.virtualbox.org/virtualbox/4.3.8/virtualbox-4.3_4.3.8-92456~Ubuntu~${vbox_download_code_name}_i386.deb"
vagrant_link="https://dl.bintray.com/mitchellh/vagrant/vagrant_${vagrant_version}_i686.deb"

function determine_32_64_bit() {
    local machine=$(uname -m)
    if ! [[ $machine =~ i686 ]] ; then
        is_32_bit=false
    fi
}

determine_32_64_bit

if ! $is_32_bit ; then
    echo "installing packages of 64-bit virtualbox and vagrant..."
    virtualbox_link="http://download.virtualbox.org/virtualbox/4.3.8/virtualbox-4.3_4.3.8-92456~Ubuntu~${vbox_download_code_name}_amd64.deb"
    vagrant_link="https://dl.bintray.com/mitchellh/vagrant/vagrant_${vagrant_version}_x86_64.deb"
fi


function install_git() {
    sudo apt-get install git
}

function install_virtualbox() {
    cd /tmp
    wget $virtualbox_link
    sudo dpkg -i virtualbox-4.3_4.3.8-92456~Ubuntu~*
    sudo apt-get install -f
    cd -
}

function install_vagrant() {
    cd /tmp
    wget $vagrant_link
    sudo dpkg -i vagrant_*
    sudo apt-get install -f
    cd -
}

sudo apt-get update
install_git
install_virtualbox
install_vagrant