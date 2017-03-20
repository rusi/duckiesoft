FROM maidbot/resin-raspberrypi3-ros

MAINTAINER rusi@me.com

RUN apt-get clean \
    && apt-get update \
    && apt-get -y -q install \
        libnss-mdns \
        python-catkin-tools \
        ros-indigo-rosbash

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/ros && \
    echo "ros:x:${uid}:${gid}:ros,,,:/home/ros:/bin/bash" >> /etc/passwd && \
    echo "ros:x:${uid}:" >> /etc/group && \
    echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ros && \
    chmod 0440 /etc/sudoers.d/ros && \
    chown ${uid}:${gid} -R /home/ros

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENTRYPOINT ["/bin/bash", "/ros_entrypoint.sh"]
CMD ["/bin/bash"]

COPY ./rosbot/ros_entrypoint.sh /ros_entrypoint.sh

USER ros
ENV HOME /home/ros
WORKDIR /home/ros/ws

COPY ./ros_ws /home/ros/ws
USER root
RUN chown ros:ros -R /home/ros/ws
USER ros
RUN /bin/bash /ros_entrypoint.sh catkin build
