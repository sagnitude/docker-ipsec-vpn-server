#!/bin/bash

# 1. build this dockerfile
# docker build -t sagnitude/ipsec-vpn-server
# 2. copy ppp directory to somewhere else
# mkdir /srv/vpn/ppp
# 3. prepare the env file
# touch /srv/vpn/vpn.env

docker run \
    --name ipsec-vpn-server \
    --env-file /srv/vpn/vpn.env \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -v /lib/modules:/lib/modules:ro \
    -d --privileged \
    --restart=always \
    --volume /srv/vpn/ppp:/etc/ppp \
    sagnitude/ipsec-vpn-server
