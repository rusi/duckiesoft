#!/bin/bash

DIR=$( cd "$(dirname "$0")" ; pwd -P )

$DIR/dkr.sh run -it --rm \
	-v ~/.ros:/root/.ros/ \
	-v ${PWD}:/workspace \
	--name ros ros:indigo $@
