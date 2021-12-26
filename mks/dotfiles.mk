FILES := $(shell yq e '.dotfiles' $(CONFIG_FILE)|sed -e 's/\- //g')


PHONY: dotfiles/install
dotfiles/install: ## Install dotfiles
	@for f in $(FILES); do \
		echo "Linking $${DOTFILES}/$${f} $${HOME}/`basename $${f}`" ; \
		ln -nfs $${DOTFILES}/$${f} $${HOME}/`basename $${f}` ; \
	done \

PHONY: dotfiles/uninstall
dotfiles/uninstall: ## Install dotfiles
	@for f in $(FILES); do \
		echo "Deleting: $${HOME}/`basename $${f}`" ; \
		rm -f $${HOME}/`basename $${f}` ; \
	done \
