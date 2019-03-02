#!/bin/bash

#modprobe pktgen

#if [[ `lsmod | grep pktgen` == "" ]]; then
#    modprobe pktgen
#fi

# load schedule parameters
echo "Load TT schedule parameters"
schedule_path="/home/chenwh/Workspace/Data/minimal"
result=$(python load_tt_sched_info.py $schedule_path 1)
info=($result)
if_id=${info[0]}
flow_id=${info[1]}
sched_time=${info[2]}
period=${info[3]}
buffer_id=${info[4]}
pkt_size=${info[5]}

# ---------------------------------------------------------------

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
pgset "pkt_size $pkt_size"
pgset "src_min 10.0.0.1"
pgset "src_max 10.0.0.1"
pgset "dst 10.0.0.2"
pgset "udp_src_min 8000"
pgset "udp_src_max 8000"
pgset "udp_dst_min 63000"
pgset "udp_dst_max 63000"
pgset "count 1000"
pgset "offset $sched_time"
pgset "delay $period"
pgset "flowid $flow_id"

# Time to run
PGDEV=/proc/net/pktgen/pgctrl

echo "Running... ctrl^C to stop"
pgset "start" 
echo "Done"
