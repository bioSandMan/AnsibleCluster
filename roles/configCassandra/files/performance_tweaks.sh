#!/bin/bash

# Set user resource limits
echo "cassandra - memlock unlimited" > /etc/security/limits.conf
echo "cassandra - nofile 100000" > /etc/security/limits.conf
echo "cassandra - nproc 32768" > /etc/security/limits.conf
echo "cassandra - as unlimited" > /etc/security/limits.conf

# we aren't running cassandra as root, but JIC
echo "root - memlock unlimited" > /etc/security/limits.conf
echo "root - nofile 100000" > /etc/security/limits.conf
echo "root - nproc 32768" > /etc/security/limits.conf
echo "root - as unlimited" > /etc/security/limits.conf


echo 0 > /proc/sys/vm/zone_reclaim_mode

# Disable defrag for hugepages
echo never | tee /sys/kernel/mm/transparent_hugepage/defrag


echo "vm.max_map_count = 1048575" > /etc/sysctl.conf

# To handle thousands of concurrent connections used by Cassandra, 
# the following settings are recommended for optimizing the Linux network stack. 
# Add these settings to /etc/sysctl.conf.
echo "net.core.rmem_max = 16777216" > /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" > /etc/sysctl.conf
echo "net.core.rmem_default = 16777216" > /etc/sysctl.conf
echo "net.core.wmem_default = 16777216" > /etc/sysctl.conf
echo "net.core.optmem_max = 40960" > /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" > /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 16777216" > /etc/sysctl.conf

# ensure swap is off and JIC it is accidentally re-enabled
swapoff -a
echo "vm.swappiness = 1" > /etc/sysctl.conf

# To set immediately
sysctl -p

# disable cpu frequency scaling
for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    [ -f $CPUFREQ ] || continue
    echo -n performance > $CPUFREQ
done