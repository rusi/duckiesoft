#!/bin/bash

DIR=$( cd "$(dirname "$0")" ; pwd -P )

source $DIR/common.sh

docker $RUN_CMD -it --rm \
	-v ~/.ros:/root/.ros/ \
	-v ${PWD}:/workspace \
	--net host \
	--env ROS_IP=172.16.25.163 \
	ros:indigo $@
