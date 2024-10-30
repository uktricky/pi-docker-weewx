docker stop weewx
docker rm weewx

docker run \
-d \
-e TZ='Europe/London' \
--volume /home/trickyweewx.conf:/home/weewx-data/weewx.conf \
--volume /home/tricky/docker/webserver/:/home/weewx/weewx-data/public_html/ \
--name weewx \
tricky-weewx:latest
