#!/bin/bash
if [ -f '/vagrant/.vagrant/.public_mac_address' ]; then
    ifconfig | grep "$(route | grep '^default' | grep -o '[^ ]*$')" | awk '{print $5}' > /vagrant/.vagrant/.public_mac_address
fi