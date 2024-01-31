#!/usr/bin/env bash

show_help() {
cat << EOF
Usage: ${0##*/} [-h|--help]

This script retrueves the MAC address of the first non-virtual network interface found on the system.

    -h, --help      Display this help and exit.

EOF
}

# Check if the help option is provided
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Retrieve the list of non-virtual network interfaces
all=$(ls -l /sys/class/net/ | grep -v virtual | awk '{print $9}')

# Get the first network interface
one=$(echo $all | cut -d " " -f 1)

# Check if an interface was found
if [[ -z "$one" ]]; then
    echo "No non-virtual network interface found."
    exit 1
fi

# Read and output the MAC address of the network interface
cat /sys/class/net/$one/address