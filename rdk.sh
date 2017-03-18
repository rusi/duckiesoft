#!/bin/bash

DUCKIEBOT_HOST=duckiebot.local

DUCKIEBOT_IP=$(ping -c 1 $DUCKIEBOT_HOST | awk -F'[()]' 'NR==1{print $2}')

CMD=""
if [ $1 == 'run' ]; then
	CMD=" run -v /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket --env ROS_MASTER_URI=http://$DUCKIEBOT_HOST:11311 --env ROS_IP=$DUCKIEBOT_IP --net host "
	shift;
fi

docker --host=$DUCKIEBOT_IP:2375 $CMD $@
