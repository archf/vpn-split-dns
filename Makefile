VPNC-SCRIPT = "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/refs/heads/master:/vpnc-script"
VPNC-SCRIPTDIR = "/usr/share/vpnc-scripts"
VPNC-HOOKDIR = "/etc/vpnc"

TARGET = ~/bin/vpn

.PHONY: install vpnc-script vpnc-hooks dnsmasq update vpn

install: vpnc-script vpnc-hooks dnsmasq $(TARGET)

# for convenience
vpn: $(TARGET)

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

# fixme: use install cmd?
dnsmasq:
	@echo "install dnsmasq custom configuration"
	for i in ~/.vpn/dnsmasq/* ; do 											\
			/bin/cp $$i /etc/NetworkManager/dnsmasq.d/ ;		\
	done

$(TARGET):
	install -D vpn $@

update:
	@git pull --rebase
