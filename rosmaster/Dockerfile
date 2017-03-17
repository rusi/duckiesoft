FROM maidbot/resin-raspberrypi3-ros

MAINTAINER rusi@me.com

RUN apt-get clean \
	&& apt-get update \
	&& apt-get install libnss-mdns

EXPOSE 11311

CMD ["roscore"]
