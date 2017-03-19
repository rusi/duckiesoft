FROM maidbot/resin-raspberrypi3-ros

MAINTAINER rusi@me.com

RUN apt-get clean \
	&& apt-get update \
	&& apt-get -y -q install \
		libnss-mdns \
		python-catkin-tools 

RUN export uid=1000 gid=1000 && \
    mkdir -p /ws && \
    echo "ros:x:${uid}:${gid}:ros,,,:/ws:/bin/bash" >> /etc/passwd && \
    echo "ros:x:${uid}:" >> /etc/group && \
    echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ros && \
    chmod 0440 /etc/sudoers.d/ros && \
    chown ${uid}:${gid} -R /ws

RUN rm /etc/ros/rosdep/sources.list.d/20-default.list \
	&& rosdep init

USER ros
ENV HOME /ws

RUN rosdep update

VOLUME ["/ws"]

WORKDIR /ws

ENTRYPOINT ["/bin/bash", "/ros_entrypoint.sh"]
CMD ["/bin/bash"]