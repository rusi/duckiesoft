#!/bin/bash

# Local Master
ROS_MASTER_URL="http://rosmaster:11311"
CONTAINER="rosdev"


DIR=$( cd "$(dirname "$0")" ; pwd -P )
HOST_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $HOST_IP

RUN_CMD="run --env ROS_MASTER_URI"
RUN_FLAGS="-it --rm"

docker ps | grep -q rosmaster
if [ $? -ne 0 ]; then
	CONTAINER="--name rosmaster $CONTAINER roscore"
	RUN_FLAGS="-d"
	echo "ROS Master NOT running... Starting..."
fi

docker $RUN_CMD $RUN_FLAGS \
	-e DISPLAY=$HOST_IP:0 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.ros:/root/.ros/ \
	-v ${PWD}:/workspace \
	--net duckienet \
	$CONTAINER $@
