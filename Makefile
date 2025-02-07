OS := $(shell uname)

##@ Utility
.PHONY: help
help: ## Display this help
	@echo "Displaying help..."
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\033[36m\033[0m\n"} /^[a-zA-Z\._-]+:.*##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: install
install: ## Setup apps
	@echo "Starting installation process..."
	@if [ "$(OS)" = "Darwin" ]; then \
		echo "Detected macOS."; \
		if ! command -v brew >/dev/null 2>&1; then \
			echo "Homebrew not found. Installing..."; \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		else \
			echo "Homebrew is already installed."; \
		fi; \
		if ! command -v brew >/dev/null 2>&1; then \
			if [ -f "/opt/homebrew/bin/brew" ]; then \
				echo "Adding Homebrew path to ~/.zshrc (Apple Silicon)"; \
				if ! grep -q 'export PATH="/opt/homebrew/bin:$$PATH"' "$$HOME/.zshrc"; then \
					echo 'export PATH="/opt/homebrew/bin:$$PATH"' >> "$$HOME/.zshrc"; \
				fi; \
				source "$$HOME/.zshrc"; \
			elif [ -f "/usr/local/bin/brew" ]; then \
				echo "No need to add Homebrew path to ~/.zshrc (Intel)"; \
			else \
				echo "Error: Homebrew installation failed or is not accessible."; \
				exit 1; \
			fi; \
		fi; \
		echo "Running Brew Bundle..."; \
		brew bundle --file=./brewfile; \
	else \
		echo "Detected Linux or unsupported OS."; \
		echo "Installing dotbot via apt-get..."; \
		sudo apt-get install -y dotbot; \
	fi
	@echo "Installation process complete."

.PHONY: macos
macos: ## Install macOS settings
	@echo "Applying macOS settings..."
	@echo "Running Dotbot for macOS..."
	@dotbot -c ./macos.yaml
	@echo "Applying macOS system settings..."
	@/usr/bin/env bash -c "./macos/macos"
	@echo "macOS setup complete."

.PHONY: linux
linux: ## Install Linux settings
	@echo "Applying Linux settings..."
	@echo "Running Dotbot for Linux..."
	@dotbot -c ./linux.yaml
	@echo "Linux setup complete."