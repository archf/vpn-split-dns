# VPN split dns

This has been mainly tested on Ubuntu 16.04 LTS.

Purpose of this is to handle properly split DNS properly with VPN connections
out of Network Manager. Will be required as long as juniper is not supported
throught NetworkManager.

## Installation

```
sudo make install
```

This will:

* install the openconnect wrapper in your path. See [openconnect wrapper](#openconnect-wrapper) below.
* install dnsmasq custom configuration files

## dnsmasq configuration

All files you put under `~/.vpn/dnsmasq.d/` will be moved to
`/etc/NetworkManager/dnsmasq.d/`. This allows to explicitely configure upstream
servers for dnsmasq when using split dns for connections not managed by
NetworkManager and avoid dns leak.

## openconnect wrapper

To install the wrapper script in `~/bin`, just do:

```
make vpn
```

usage: `sudo vpn <customer> up|down`

Where <customer> is a file `~/.vpn/` of the form `<customer>.conf` where each
line contains valid openconnect argument.

E.G:

```
--juniper
--user=foo
--interface=<myifacename>
<vpn gateway url>
```
