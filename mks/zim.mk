ZIM_INSTALL_URL := $(shell yq e '.urls.zim.install' $(CONFIG_FILE))


.PHONY: zim/install
zim/install: ## zim install
	@echo "This task is not fully automated, take a look here: $(ZIM_INSTALL_URL)"
	@curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
	@echo "Open a new terminal and execute: zimfw install and then make dotfiles/install"

.PHONY: zim/uninstall
zim/uninstall: ## zim uninstall
	@rm -fr $(HOME)/.zim
