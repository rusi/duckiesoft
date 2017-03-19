#!/bin/bash

# to check for unset var, use [ -z ${DUCKIEBOT_HOST+x} ]
# but here we want to know that it is also NOT empty
if [ -z "$DUCKIEBOT_HOST" ]; then
	DUCKIEBOT_HOST=duckiebot.local
fi

DUCKIEBOT_IP=$(ping -c 1 $DUCKIEBOT_HOST | awk -F'[()]' 'NR==1{print $2}')
HOST_IP=$(ping -c 1 -R $DUCKIEBOT_HOST | awk 'NR==5{print $1}' | sed 's/ //')
#HOST_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

RUN_CMD=" run --env ROS_MASTER_URI=http://$DUCKIEBOT_IP:11311 "
