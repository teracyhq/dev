#! /bin/bash

ipaddress=`hostname -I | cut -d' ' -f2`
echo "ip address: $ipaddress"
