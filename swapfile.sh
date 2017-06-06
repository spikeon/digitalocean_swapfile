#!/bin/bash

echo "Basic Server Setup";
echo "DigitalOcean 16.04";

echo "SwapFile:";

if [ ! -e "/swapfile" ]; then
    echo "Creating SwapFile";
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    swapon --show
    echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
else
    echo "SwapFile Exists"
fi


echo "Swappiness Setting"

SWAPPINESS=$(cat /proc/sys/vm/swappiness)
if (( SWAPPINESS > 10 )) ; then 
    echo "Setting Swappiness"
    sysctl vm.swappiness=10
    echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
else
    echo "Swappiness is already correct"
fi

echo "Pressure Setting"

PRESSURE=$(cat /proc/sys/vm/vfs_cache_pressure)
if (( PRESSURE > 50 )) ; then
    echo "Setting Pressure"

    sysctl vm.vfs_cache_pressure=50
    echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
else
    echo "Pressure is already correct"
fi

echo "Completed"

