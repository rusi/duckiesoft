#!/bin/bash

DUCKIEBOT_HOST=duckiebot.local
DUCKIEBOT_IP=$(ping -c 1 $DUCKIEBOT_HOST | awk -F'[()]' 'NR==1{print $2}')

HOST_IP=$(ping -c 1 -R $DUCKIEBOT_HOST | awk 'NR==5{print $1}' | sed 's/ //')

RUN_CMD=" run --env ROS_MASTER_URI=http://$DUCKIEBOT_IP:11311 "