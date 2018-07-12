#! /bin/bash
# this command is the same as from lib/utility.rb
ipaddress=`LANG=en ifconfig | grep 'inet addr:192.168' | cut -d: -f2 | awk '{ print $1 }'`
echo "LAN IP Address: $ipaddress"
