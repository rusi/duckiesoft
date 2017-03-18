FROM ros:indigo

MAINTAINER rusi@me.com

RUN apt-get clean \
    && apt-get update \
    && apt-get -y -q install wget

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -

RUN apt-get clean \
    && apt-get update \
    && apt-get install python-catkin-tools


VOLUME ["/workspace"]

WORKDIR /workspace

