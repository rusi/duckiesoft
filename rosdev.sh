#!/bin/bash

# Local Master
if [ -z "$ROS_MASTER_URI" ]; then
	ROS_MASTER_URI="http://rosmaster:11311"
fi
echo $ROS_MASTER_URI
CONTAINER="rosdev"


DIR=$( cd "$(dirname "$0")" ; pwd -P )
HOST_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $HOST_IP

RUN_CMD="run --env ROS_MASTER_URI=$ROS_MASTER_URI"
RUN_FLAGS="-it --rm"

docker network ls | grep -q duckienet
if [ $? -ne 0 ]; then
	echo "Duckienet missing; creating..."
	docker network create duckienet
fi

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
