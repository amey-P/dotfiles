#! /bin/bash

echo $(cargo --version)
if ! cargo --version; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.cargo/env
fi

cargo install exa bat fd-find zoxide macchina
cargo install --locked nu yazi-fm yazi-cli

