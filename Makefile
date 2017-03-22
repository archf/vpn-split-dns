VPNC-SCRIPT = "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/refs/heads/master:/vpnc-script"
VPNC-SCRIPTDIR = "/usr/share/vpnc-scripts"
VPNC-HOOKDIR = "/etc/vpnc"
BIN = ~/bin/vpn
SYSTEMD_LOAD_PATH = /lib/systemd/system
SYSTEMD_USER_LOAD_PATH = ~/.config/systemd/user
SERVICES = $(SYSTEMD_LOAD_PATH)/openconnect@.service

# source of a vpn environment files
VPN_ENV_SRC = ~/.vpn/vpn-env
# dest of a vpn environment files
VPN_ENV_PATH = /etc/vpn

.PHONY: install vpnc-script vpnc-hooks dnsmasq update vpn

install: vpnc-script vpnc-hooks dnsmasq $(BIN) $(SERVICES)

vpnc-script:
	@echo "backup old vpnc-script"
	mv $(VPNC-SCRIPTDIR)/vpnc-script \
		$(VPNC-SCRIPTDIR)/vpnc-script.$$(date "+%Y%m%d%S")

	wget $(VPNC-SCRIPT) -O $(VPNC-SCRIPTDIR)/vpnc-script
	chown root:root /usr/share/vpnc-scripts/vpnc-script
	chmod +x /usr/share/vpnc-scripts/vpnc-script

# fixme: use install cmd?
vpnc-hooks:
	@echo "install hooks from 'hooks.d'"
	chmod +x $(VPNC-HOOKDIR)
	for i in hooks.d/* ; do 									\
			/bin/cp -r $$i $(VPNC-HOOKDIR)/ ;			\
	done

dnsmasq:
	@echo "install dnsmasq custom configuration"
	for i in ~/.vpn/dnsmasq/* ; do 											\
			install $$i /etc/NetworkManager/dnsmasq.d/ ;		\
	done

update:
	@git pull --rebase

.PHONY: vpn
vpn: $(BIN)

$(BIN):
	ln -s $(PWD)/$(@F) $@
	@echo "All done! Make sure ~/bin is in your PATH"

.PHONY: systemd_services
systemd_services: $(SERVICES)

$(SERVICES):
	install -m 622 $(PWD)/$(@F) $@

# install all environment files for systemd templated units
.PHONY: vpnenv
vpnenv:
	rsync --recursive --delete $(VPN_ENV_SRC)/* $(VPN_ENV_PATH)/
