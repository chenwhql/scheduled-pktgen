#!/bin/bash

#modprobe pktgen

#if [[ `lsmod | grep pktgen` == "" ]]; then
#    modprobe pktgen
#fi

function pgset() {
    local result

    echo $1 > $PGDEV

    result=`cat $PGDEV | fgrep "Result: OK:"`
    if [ "$result" = "" ]; then
         cat $PGDEV | fgrep Result:
    fi
}

function pg() {
    echo inject > $PGDEV
    cat $PGDEV
}

# Config Start Here -----------------------------------------------------------


# thread config
# Each CPU has own thread. Two CPU exammple.

PGDEV=/proc/net/pktgen/kpktgend_0
echo "Removing all devices"
pgset "rem_device_all" 
echo "Adding h1-eth0"
pgset "add_device h1-eth0" 
echo "Setting max_before_softirq 1"
pgset "max_before_softirq 1"

PGDEV=/proc/net/pktgen/h1-eth0
  echo "Configuring $PGDEV"

#pgset "clone_skb 1000"
pgset "pkt_size 64"
pgset "src_min 10.0.0.1"
pgset "src_max 10.0.0.1"
pgset "dst 10.0.0.2"
pgset "udp_src_min 8000"
pgset "udp_src_max 8000"
pgset "udp_dst_min 63000"
pgset "udp_dst_max 63000"
pgset "count 100"
pgset "delay 1000000000"

# Time to run
PGDEV=/proc/net/pktgen/pgctrl

echo "Running... ctrl^C to stop"
pgset "start" 
echo "Done"
