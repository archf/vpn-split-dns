VPNC-SCRIPT = "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/refs/heads/master:/vpnc-script"
# Debian/Ubuntu
VPNC-SCRIPTDIR = /usr/share/vpnc-scripts
# Fedora/RHEL/CentOS
# VPNC-SCRIPTDIR = /etc/vpnc
VPNC-HOOKDIR = /etc/vpnc
BIN = ~/bin/vpn
SUCCESS_MSG = "All done! Make sure ~/bin is in your PATH"

.PHONY: install vpnc-script vpnc-hooks update vpn uninstall

install: vpnc-script vpnc-hooks $(BIN)

vpnc-script:
	@echo "updating to most recent vpnc-script"
	@echo "backup old vpnc-script directory first..."
	/bin/mv $(VPNC-SCRIPTDIR)/vpnc-script \
		$(VPNC-SCRIPTDIR)/vpnc-script.$$(date "+%Y%m%d%S")
	@echo "...done"
	@echo "installing latest vpnc-script"
	/usr/bin/wget $(VPNC-SCRIPT) -O $(VPNC-SCRIPTDIR)/vpnc-script
	/bin/chown root:root $(VPNC-SCRIPTDIR)/vpnc-script
	/bin/chmod +x $(VPNC-SCRIPTDIR)/vpnc-script

vpnc-hooks:
	@echo "install hooks from '~/.vpn/hooks.d'"
	chmod +x $(VPNC-HOOKDIR)
	for i in hooks.d/* ; do	\
		/usr/bin/sudo	/usr/bin/install -r $$i $(VPNC-HOOKDIR)/ ; \
		done

# dnsmasq:
# 	@echo "install dnsmasq custom configuration"
# 	for i in ~/.vpn/dnsmasq.d/* ; do \
# 		/usr/bin/sudo /bin/cp $$i /etc/NetworkManager/dnsmasq.d/ ; \
# 		done

update:
	@git pull --rebase

.PHONY: vpn
vpn: $(BIN)

$(BIN):
	ln -s $(CURDIR)/$(@F) $@
	@echo $(SUCCESS_MSG)

uninstall:
	rm -f $(BIN)
