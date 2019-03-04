#!/bin/bash

# load schedule info
schedule_path="/home/chenwh/Workspace/Data/minimal"
result=$(python load_tt_sched_info.py $schedule_path 1)
info=($result)
if_id=${info[0]}
flow_id=${info[1]}
sched_time=${info[2]}
period=${info[3]}
buffer_id=${info[4]}
pkt_size=${info[5]}
echo $if_id
echo $pkt_size
