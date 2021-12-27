ZIM_INSTALL_URL   := $(shell yq e '.urls.zim.install' $(CONFIG_FILE))
ZIM_UNINSTALL_URL := $(shell yq e '.urls.zim.uninstall' $(CONFIG_FILE))

.PHONY: zim/install
zim/install: ## zim install
	@echo "This task is not automated, take a look here: $(ZIM_INSTALL_URL)"

.PHONY: zim/uninstall
zim/uninstall: ## zim uninstall
	@echo "This task is not automated, take a look here: $(ZIM_UNINSTALL_URL)"
