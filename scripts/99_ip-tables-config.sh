#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Configuring iptables"
echo "-----------------------------------------------------------"

iptables -A INPUT -p tcp -m tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables-save

echo "-----------------------------------------------------------"
echo "Finished - Configuring iptables"
echo "-----------------------------------------------------------"
