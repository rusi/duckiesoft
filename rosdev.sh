#!/bin/bash

DIR=$( cd "$(dirname "$0")" ; pwd -P )

source $DIR/common.sh

xhost + $HOST_IP

# Comment out the next line if you want to use Duckiebot's ROS Master
RUN_CMD="run --env ROS_MASTER_URI=http://rosmaster:11311"

docker $RUN_CMD -it --rm \
	-e DISPLAY=$HOST_IP:0 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.ros:/root/.ros/ \
	-v ${PWD}:/workspace \
	--net duckienet \
	rosdev $@

	#--name rosmaster \
