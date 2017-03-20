FROM ros:indigo

MAINTAINER rusi@me.com

RUN apt-get clean \
    && apt-get update \
    && apt-get -y -q install \
        wget \
        build-essential

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -

RUN apt-get update \
    && apt-get -y -q install \
        python-catkin-tools \
        ros-indigo-rqt ros-indigo-rqt-common-plugins \
        ros-indigo-rosbash \
        ros-indigo-image-view ros-indigo-image-transport-plugins

RUN apt-get update \
    && apt-get -y -q install \
        ros-${ROS_DISTRO}-ros-tutorials

RUN rm /etc/ros/rosdep/sources.list.d/20-default.list \
	&& rosdep init

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/ros && \
    echo "ros:x:${uid}:${gid}:ros,,,:/home/ros:/bin/bash" >> /etc/passwd && \
    echo "ros:x:${uid}:" >> /etc/group && \
    echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ros && \
    chmod 0440 /etc/sudoers.d/ros && \
    chown ${uid}:${gid} -R /home/ros

USER ros
ENV HOME /home/ros

RUN rosdep update

VOLUME ["/home/ros/ws"]

WORKDIR /home/ros/ws

