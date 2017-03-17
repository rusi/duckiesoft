#!/bin/bash

DIR=$( cd "$(dirname "$0")" ; pwd -P )

DUCKIEBOT_HOST=duckiebot.local

DUCKIEBOT_IP=$(ping -c 1 $DUCKIEBOT_HOST | awk -F'[()]' 'NR==1{print $2}')

CMD=""
if [ $1 == 'run' ]; then
	CMD=" run --env ROS_MASTER_URI=http://$DUCKIEBOT_IP:11311 "
	shift;
fi

docker $CMD $@
