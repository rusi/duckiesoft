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
        ros-indigo-rqt ros-indigo-rqt-common-plugins

RUN apt-get update \
    && apt-get -y -q install \
        ros-${ROS_DISTRO}-ros-tutorials

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /workspace && \
    echo "ros:x:${uid}:${gid}:ros,,,:/workspace:/bin/bash" >> /etc/passwd && \
    echo "ros:x:${uid}:" >> /etc/group && \
    echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ros && \
    chmod 0440 /etc/sudoers.d/ros && \
    chown ${uid}:${gid} -R /workspace

USER ros
ENV HOME /workspace

VOLUME ["/workspace"]

WORKDIR /workspace

