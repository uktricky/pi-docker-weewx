docker stop weewx
docker rm weewx

mkdir ~/docker/weewx
mkdir ~/docker/weewx/db
mkdir ~/docker/weewx/skins

docker run \
-d \
-e TZ='Europe/London' \
-v /home/tricky/docker/weewx/weewx.conf:/home/weewx/weewx-data/weewx.conf \
-v /home/tricky/docker/weewx/db:/home/weewx/weewx-data/archive \
-v /home/tricky/docker/webserver/:/home/weewx/weewx-data/public_html/ \
-v /home/tricky/docker/weewx/usrbin/gw1000.py:/home/weewx/weewx-data/bin/user/gw1000.py \
-v /home/tricky/docker/weewx/skins:/home/weewx/weewx-data/skins \
--name weewx \
tricky-weewx:latest



#-v /home/tricky/docker/weewx/weewx.conf:/home/weewx/weewx-data/weewx.conf \
#-v /home/tricky/docker/weewx/skins:/home/weewx/weewx-data/skins \
