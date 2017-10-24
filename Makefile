VPNC-SCRIPT = "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/refs/heads/master:/vpnc-script"
VPNC-SCRIPTDIR = "/usr/share/vpnc-scripts"
VPNC-HOOKDIR = "/etc/vpnc"
BIN = ~/bin/vpn
SUCCESS_MSG = "All done! Make sure ~/bin is in your PATH"

.PHONY: install vpnc-script vpnc-hooks dnsmasq update vpn uninstall

install: vpnc-script vpnc-hooks dnsmasq $(BIN)

vpnc-script:
	@echo "updating to most recent vpnc-script"
	@echo "backup old vpnc-script"
	/bin/mv $(VPNC-SCRIPTDIR)/vpnc-script \
		$(VPNC-SCRIPTDIR)/vpnc-script.$$(date "+%Y%m%d%S")
	@echo "installing latest vpnc-script"
	/usr/bin/wget $(VPNC-SCRIPT) -O $(VPNC-SCRIPTDIR)/vpnc-script
	/bin/chown root:root /usr/share/vpnc-scripts/vpnc-script
	/bin/chmod +x /usr/share/vpnc-scripts/vpnc-script

vpnc-hooks:
	@echo "install hooks from '~/.vpn/hooks.d'"
	chmod +x $(VPNC-HOOKDIR)
	for i in hooks.d/* ; do	\
		/usr/bin/sudo	/bin/cp -r $$i $(VPNC-HOOKDIR)/ ; \
		done

dnsmasq:
	@echo "install dnsmasq custom configuration"
	for i in ~/.vpn/dnsmasq.d/* ; do \
		/usr/bin/sudo /bin/cp $$i /etc/NetworkManager/dnsmasq.d/ ; \
		done

update:
	@git pull --rebase

.PHONY: vpn
vpn: $(BIN)

$(BIN):
	ln -s $(PWD)/$(@F) $@
	@echo $(SUCCESS_MSG)

uninstall:
	rm -f $(BIN)
