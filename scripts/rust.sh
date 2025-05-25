#! /bin/bash

if ! cargo --version; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.cargo/env
fi

cargo install --locked nu exa bat fd-find zoxide macchina
# cargo install --locked yazi-fm yazi-cli  # Installed Using SNAP
