#!/bin/bash

# Guide  users to generate ssh-keys for the first time when users login to the virtual machine.

is_done=false

function check_done() {
    if grep -q 'done' ~/.teracy/ssh_check ; then
        is_done=true
    fi
}

function copy_from_cookbook() {
    cp /vagrant/cookbooks/teracy-dev/files/default/id_rsa* ~/.ssh
    echo "id_rsa* keys from cookbook was copied into this virtual machine."  
}

function copy_to_cookbook() {
    cp ~/.ssh/id_rsa* /vagrant/cookbooks/teracy-dev/files/default
    echo "id_rsa* keys from this virtual machine was copied into the cookbook."
}

# try to copies ssh keys from /vagrant/cookbooks/teracy-dev/files/default/id_rsa and 
# /vagrant/cookbooks/teracy-dev/files/default/id_rsa, if yes, is_done=true
function try_copying_ssh_keys_from_cookbook() {
    if [ -f /vagrant/cookbooks/teracy-dev/files/default/id_rsa ] && 
       [ -f /vagrant/cookbooks/teracy-dev/files/default/id_rsa.pub ] ; then

        copy_from_cookbook
        if grep -q 'done' ~/.teracy/ssh_check ; then
            echo 'done' >> ~/.teracy/ssh_check
        fi
    fi
}

function generate_ssh_keys() {
    read -p "As you allow to generate new ssh keys, please enter your email and press [ENTER]: " email
    ssh-keygen -t rsa -C $email
    copy_to_cookbook
    echo 'done' >> ~/.teracy/ssh_check
}

# always copy id_rsa* from cookbook into the virtual machine
try_copying_ssh_keys_from_cookbook

check_done

if ! $is_done ; then
    generate_ssh_keys
fi
