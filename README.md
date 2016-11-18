# vpn split dns setup

This has been mainly tested on Ubuntu 16.04 LTS.

# Installation

```
sudo make install
```

# dnsmasq configuration

All files you put under `~/.vpn.dnsmasq/` will be moved to
`/etc/NetworkManager/dnsmasq.d/`. This allows to configure upstream servers for
dnsmasq when using split dns for connections not managed by NetworkManager.

# openconnect wrapper

To install the wrapper script i `~/bin`, just do:

```
make vpn
```

usage: `sudo vpn <customer> up|down`

Where <customer> is a file `~/.vpn/` of the form <customer>.conf
