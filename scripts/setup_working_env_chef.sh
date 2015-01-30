#!/bin/bash

# Setup initial working environment for host machines. This initial script only serves Ubuntu.
#
# install git
# install virtualbox-4.3.20
# install vagrant 1.7.1

function command_exists() {
    type "$1" &> /dev/null;
}

distributor_id=`command_exists lsb_release && lsb_release -i`


if [[ "$distributor_id" != *Ubuntu* ]]; then
    echo "You're not on Ubuntu. This script is currently provided to run under Ubuntu only."
    exit 1
fi

code_name=$(lsb_release -a 2>&1 | grep Codename | awk '{print $2}')
vagrant_version="1.7.1"

if [ "$code_name" == "trusty" ] || [ "$code_name" == "saucy" ] || [ "$code_name" == "utopic" ]; then
    vbox_download_code_name="raring"
else
    vbox_download_code_name="$code_name"
fi

is_32_bit=true
virtualbox_link="http://download.virtualbox.org/virtualbox/4.3.20/virtualbox-4.3_4.3.20-96996~Ubuntu~${vbox_download_code_name}_i386.deb"
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
    virtualbox_link="http://download.virtualbox.org/virtualbox/4.3.20/virtualbox-4.3_4.3.20-96996~Ubuntu~${vbox_download_code_name}_amd64.deb"
    vagrant_link="https://dl.bintray.com/mitchellh/vagrant/vagrant_${vagrant_version}_x86_64.deb"
fi


function install_git() {
    sudo apt-get -f -y install git
}

function install_virtualbox() {
    cd /tmp
    wget $virtualbox_link
    sudo dpkg -i virtualbox-*~Ubuntu~*
    sudo apt-get install -f -y
    cd -
}

function install_vagrant() {
    cd /tmp
    wget $vagrant_link
    sudo dpkg -i vagrant_*
    sudo apt-get install -f -y
    cd -
}

function install_docker() {
    sudo apt-get update
    if [ "$code_name" == "precise" ]; then
        sudo apt-get install linux-image-generic-lts-raring linux-headers-generic-lts-raring
        sudo apt-get install --install-recommends linux-generic-lts-raring xserver-xorg-lts-raring libgl1-mesa-glx-lts-raring
        sudo apt-get install -f
        [ -e /usr/lib/apt/methods/https ] || {
          apt-get install apt-transport-https
        }
    else
        sudo apt-get install linux-image-extra-`uname -r`
    fi
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
    sudo sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
    sudo apt-get update
    sudo apt-get -f -y install lxc-docker
}

sudo apt-get update
install_git
install_virtualbox
install_vagrant
#install_docker
