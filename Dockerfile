FROM debian:bookworm-slim

# Stolen from docker-weewx
LABEL maintainer="Richard Town <rick@tricky.me.uk>"
ENV VERSION=5.1.0
ENV TAG=v5.1.0
ENV WEEWX_ROOT=/home/weewx/weewx-data
ENV WEEWX_VERSION=5.1.0
ENV HOME=/home/weewx
ENV TZ=Europe/London
ENV PATH=/usr/bin:$PATH

#    &&  apt-get install curl bash python3 python3-dev python3-pip python3-venv gcc libc-dev libffi-dev tzdata rsync openssh-client openssl git -y

RUN apt-get update \
    &&  apt-get install wget unzip python3 python3-dev python3-pip python3-venv tzdata rsync openssh-client openssl git libffi-dev python3-setuptools libjpeg-dev python3-six -y \
    &&  addgroup weewx \
    && useradd -m -g weewx weewx \
    && chown -R weewx:weewx /home/weewx \
    && chmod -R 755 /home/weewx

USER weewx

RUN python3 -m venv /home/weewx/weewx-venv \
    && chmod -R 755 /home/weewx \
    && . /home/weewx/weewx-venv/bin/activate \
    && python3 -m pip install Pillow \
    && python3 -m pip install CT3 \
    && python3 -m pip install configobj \
    && python3 -m pip install paho-mqtt \
    && python3 -m pip install six \
    # If your hardware uses a serial port
    && python3 -m pip install pyserial \
    # If your hardware uses a USB port
    && python3 -m pip install pyusb \
    # If you want extended celestial information:
    && python3 -m pip install ephem \
    # If you use MySQL or Maria
    && python3 -m pip install PyMySQL \
    # If you use sqlite
    && python3 -m pip install db-sqlite3 \
    && git clone https://github.com/weewx/weewx ~/weewx \
    && cd ~/weewx \
    && git checkout $TAG \
    && . /home/weewx/weewx-venv/bin/activate \
    && python3 ~/weewx/src/weectl.py station create --no-prompt

COPY conf-fragments/* /home/weewx/tmp/conf-fragments/

RUN mkdir -p /home/weewx/tmp \
    && cat /home/weewx/tmp/conf-fragments/* >> /home/weewx/weewx-data/weewx.conf

## Belchertown extension
RUN cd /var/tmp \
  && . /home/weewx/weewx-venv/bin/activate \
  && wget https://github.com/poblabs/weewx-belchertown/releases/download/weewx-belchertown-1.3.1/weewx-belchertown-release.1.3.1.tar.gz \
  && tar zxvf weewx-belchertown-release.1.3.1.tar.gz \
  && cd weewx-belchertown-master \
  && python3 ~/weewx/src/weectl.py extension install -y . \
  && cd /var/tmp \
  && rm -rf weewx-belchertown-release.1.3.1.tar.gz weewx-belchertown-master \

## MQTT extension
  && wget -O weewx-mqtt.zip https://github.com/matthewwall/weewx-mqtt/archive/master.zip \
  && unzip weewx-mqtt.zip \
  && cd weewx-mqtt-master \
  && . /home/weewx/weewx-venv/bin/activate \
  && python3 ~/weewx/src/weectl.py extension install -y . \
  && cd /var/tmp \
  && rm -rf weewx-mqtt.zip weewx-mqtt-master

## SKIN copy .... 
RUN cd /var/tmp \
  && wget -O weewx-skin.zip https://github.com/seehase/neowx-material/archive/refs/heads/master.zip \
  && unzip weewx-skin.zip \
  && cd neowx-material-master \
  && cp -r src /home/weewx/weewx-data/skins/src \
  && mv /home/weewx/weewx-data/skins/src /home/weewx/weewx-data/skins/neowx-material \
  && cp bin/user/historygenerator.py /home/weewx/weewx-data/bin/user/historygenerator.py \
  && cd /var/tmp \
  && rm -rf weewx-skin.zip neowx-material-master

# COPY weewx-data/* /home/weewx/ 

ADD ./bin/run.sh $WEEWX_ROOT/bin/run.sh
CMD ["sh", "-c", "$WEEWX_ROOT/bin/run.sh"]
WORKDIR $WEEWX_ROOT

