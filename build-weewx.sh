docker stop weewx
docker rm weewx

docker image rm tricky-weewx

docker build --no-cache -t tricky-weewx .

docker image ls
