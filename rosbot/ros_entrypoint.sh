#!/bin/bash
set -e

# Set up ROS environment
source "/opt/ros/${ROS_DISTRO}/setup.bash"

if [ -e /dev/vchiq ]; then
    sudo chmod 0777 /dev/vchiq
fi

exec "$@"