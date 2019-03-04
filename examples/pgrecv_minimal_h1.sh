#!/bin/bash

function pgset() {
    local result

    echo $1 > $PGDEV

    result=`cat $PGDEV | fgrep "Result: OK:"`
    if [ "$result" = "" ]; then
         cat $PGDEV | fgrep Result:
    fi
}

#---------------------------------------------------

#Disable autonegotion in the iterface
#/bin64/ethtool -A h2-eth0 autoneg off rx off tx off

# Reception configuration
PGDEV=/proc/net/pktgen/pgrx
dev=h1-eth0
mode=counter

echo "Removing old config"
pgset "rx_reset"
echo "Adding rx $dev"
pgset "rx $dev"
echo "Setting statistics $mode"
pgset "statistics $mode"
pgset "display human"
# pgset "display script"

# Result can be vieved in /proc/net/pktgen/eth1
#cat /proc/net/pktgen/pgrx
