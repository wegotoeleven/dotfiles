OS := $(shell uname)

##@ Utility
.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\033[36m\033[0m\n"} /^[a-zA-Z\._-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: install
install: ## Setup apps

	[[ $(OS) == "Darwin" ]] && brew bundle --file ./brewfile || sudo apt-get install dotbot

.PHONY: macos
macos: ## Install macos settings

	dotbot -c ./macos.yaml
	/usr/bin/env bash -c "./macos/macos.sh"