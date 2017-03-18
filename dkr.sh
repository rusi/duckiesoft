#!/bin/bash

DIR=$( cd "$(dirname "$0")" ; pwd -P )
source $DIR/common.sh

CMD=""
if [ $1 == 'run' ]; then
	CMD=$RUN_CMD
	shift;
fi

docker $CMD $@
