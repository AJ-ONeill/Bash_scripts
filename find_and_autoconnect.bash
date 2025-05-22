#!/bin/bash

echo -e "Below is a list of already paired Bluetooth devices / MAC addresses:\n"
bluetoothctl devices
echo

# Variable with known MAC address
jbl="20:64:DE:0E:5A:1D"

# Check if the JBL device is already connected
connection_status=$(bluetoothctl info "$jbl" | grep "Connected: yes")

if [ -n "$connection_status" ]; then
    echo -e "\nDevice $jbl is already connected. Exiting script."
    exit 0
fi

# If not connected, check if it's a known device
if bluetoothctl devices | grep -q "$jbl"; then
    echo -e "\nKnown device $jbl found. Attempting to connect..."
    bluetoothctl connect "$jbl" > /dev/null 2>&1

    sleep 2

    # Recheck connection
    if bluetoothctl info "$jbl" | grep -q "Connected: yes"; then
        echo "Successfully connected to $jbl"
        exit 0
    else
        echo "Failed to connect to $jbl. Please choose another device."
    fi
fi

# Prompt user to enter another MAC address
echo -e "\nPlease enter the MAC address of the paired device you wish to connect:"
read mac

echo -e "\nConnecting to $mac..."
bluetoothctl connect "$mac"
