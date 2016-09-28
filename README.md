# IPsec VPN Server on Docker

Docker image to run an IPsec VPN server, with both `IPsec/L2TP` and `IPsec/XAuth ("Cisco IPsec")`.

Based on Debian Jessie with [Libreswan](https://libreswan.org) (IPsec VPN software) and [xl2tpd](https://github.com/xelerance/xl2tpd) (L2TP daemon).

*Read this in other languages: [English](https://github.com/hwdsl2/docker-ipsec-vpn-server/blob/master/README.md), [Chinese](https://github.com/hwdsl2/docker-ipsec-vpn-server/blob/master/README-zh.md).*

## Download

```
docker pull hwdsl2/ipsec-vpn-server
```

## How to use this image

### Environment variables

This Docker image uses the following three environment variables, that can be declared in an `env` file:

```
VPN_IPSEC_PSK=<IPsec pre-shared key>
VPN_USER=<VPN Username>
VPN_PASSWORD=<VPN Password>
```

This will create a single user account for VPN login. The IPsec PSK (pre-shared key) is specified by the `VPN_IPSEC_PSK` environment variable. The VPN username is defined in `VPN_USER`, and VPN password is specified by `VPN_PASSWORD`.

**Note 1:** In your `env` file, DO NOT put single or double quotes around values, or add space around `=`. Also, DO NOT use these characters within values: `\ " '`

**Note 2:** The same VPN account can be used by your multiple devices. However, due to a limitation of the IPsec protocol, if these devices are behind the same NAT (e.g. home router), they cannot simultaneously connect to the VPN server.

All the variables to this image are optional, which means you don't have to type in any environment variable, and you can have an IPsec VPN server out of the box! Read the sections below for details.

### Start the IPsec VPN server

(Important) First, run this command on the Docker host to load the IPsec `NETKEY` kernel module:

```
sudo modprobe af_key
```

Start a new Docker container with the following command (replace `./vpn.env` with your own `env` file) :

```
docker run \
    --name ipsec-vpn-server \
    --env-file ./vpn.env \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -v /lib/modules:/lib/modules:ro \
    -d --privileged \
    --restart=always \
    hwdsl2/ipsec-vpn-server
```

### Retrieve VPN login details

If you did not set environment variables via an `env` file, `VPN_USER` will default to `vpnuser` and both `VPN_IPSEC_PSK` and `VPN_PASSWORD` will be randomly generated. To retrieve them, show the logs of the running container:

```
docker logs ipsec-vpn-server
```

Search for these lines in the output:

```
Connect to your new VPN with these details:

Server IP: <VPN Server IP>
IPsec PSK: <IPsec pre-shared key>
Username: <VPN Username>
Password: <VPN Password>
```

### Check server status

To check the status of your IPsec VPN server, you can pass `ipsec status` to your container like this:

```
docker exec -it ipsec-vpn-server ipsec status
```

## Next steps

Get your computer or device to use the VPN. Please refer to:

[Configure IPsec/L2TP VPN Clients](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients.md)   
[Configure IPsec/XAuth ("Cisco IPsec") VPN Clients](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-xauth.md)

Enjoy your very own VPN!

## Technical details

There are two services running: `Libreswan (pluto)` for the IPsec VPN, and `xl2tpd` for L2TP support.

Clients are configured to use [Google Public DNS](https://developers.google.com/speed/public-dns/) when the VPN connection is active.

The default IPsec configuration supports:

* IKEv1 with PSK and XAuth ("Cisco IPsec")
* IPsec/L2TP with PSK

The ports that are exposed for this container to work are:

* 4500/udp and 500/udp for IPsec

## See also

* [IPsec VPN Server on Ubuntu, Debian and CentOS](https://github.com/hwdsl2/setup-ipsec-vpn)
* [IKEv2 VPN Server on Docker](https://github.com/gaomd/docker-ikev2-vpn-server)
