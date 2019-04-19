#!/bin/bash
make clean
make
rmmod pktgen
insmod pktgen.ko
