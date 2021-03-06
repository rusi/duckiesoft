#!/bin/bash

# to check for unset var, use [ -z ${DUCKIEBOT_HOST+x} ]
# but here we want to know that it is also NOT empty
if [ -z "$DUCKIEBOT_HOST" ]; then
	DUCKIEBOT_HOST=duckiebot.local
fi

DUCKIEBOT_IP=$(ping -c 1 $DUCKIEBOT_HOST | awk -F'[()]' 'NR==1{print $2}')

CMD=""
if [ $1 == 'run' ]; then
	CMD=" run --privileged -v /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket -v /lib/modules:/lib/modules -v /lib/firmware:/lib/firmware -v /run/dbus:/host/run/dbus --net host"
	shift;
fi
# --env ROS_MASTER_URI=http://$DUCKIEBOT_HOST:11311 
# --env ROS_IP=$DUCKIEBOT_IP

docker --host=$DUCKIEBOT_IP:2375 $CMD $@
