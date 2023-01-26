#!/bin/sh

# docker pull gakaki/spring_base:latest
# docker pull gakaki/spring_build:latest
docker build --no-cache -t gakaki/spring_template -f Dockerfile .
docker run -it gakaki/spring_template
