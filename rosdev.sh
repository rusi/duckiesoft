#!/bin/bash

DIR=$( cd "$(dirname "$0")" ; pwd -P )

source $DIR/common.sh

xhost + $HOST_IP

CONTAINER="rosdev"
RUN_FLAGS="-it --rm"

docker ps | grep -q rosdev
if [ $? -ne 0 ]; then
	CONTAINER="--name rosmaster rosdev roscore"
	RUN_FLAGS="-d"
	echo "ROS Master NOT running... Starting..."
fi

# Comment out the next line if you want to use Duckiebot's ROS Master
RUN_CMD="run --env ROS_MASTER_URI=http://rosmaster:11311"


docker $RUN_CMD $RUN_FLAGS \
	-e DISPLAY=$HOST_IP:0 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.ros:/root/.ros/ \
	-v ${PWD}:/workspace \
	--net duckienet \
	$CONTAINER $@
