#!/bin/bash
# Layer 2: Cargo/Rust toolchain and tools
# Installs rustup and cargo binaries.
# Tool lists live in home/.chezmoidata.yaml, not here.

set -uo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/logger.sh
source "$SOURCE_DIR/lib/logger.sh"
# shellcheck source=../lib/detection.sh
source "$SOURCE_DIR/lib/detection.sh"
# shellcheck source=../lib/state.sh
source "$SOURCE_DIR/lib/state.sh"
# shellcheck source=../lib/packages.sh
source "$SOURCE_DIR/lib/packages.sh"

# shellcheck source=/dev/null
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# crate name -> installed binary, where they differ
crate_binary() {
    case "$1" in
        fd-find) echo fd ;;
        ripgrep) echo rg ;;
        yazi-fm) echo yazi ;;
        yazi-cli) echo ya ;;
        *) echo "$1" ;;
    esac
}

main() {
    local os
    os=$(detect_os)

    log_section "Layer 2: Cargo Tools"

    if [[ "$os" == "termux" ]]; then
        log_info "Skipping cargo on Termux"
        return 0
    fi

    # Install rustup if needed
    if ! command -v rustup &>/dev/null; then
        step "rustup" || return $?
        log_info "Installing rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    else
        log_info "rustup already installed"
        sentinel_mark "rustup"
    fi

    # Source cargo env
    # shellcheck source=/dev/null
    [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

    step "cargo-tools" || return $?

    local tools
    mapfile -t tools < <(read_list "cargo_tools")

    if [[ ${#tools[@]} -eq 0 ]]; then
        log_warn "No cargo tools defined in $PKG_DATA_FILE"
        return 0
    fi

    # Install missing tools
    for tool in "${tools[@]}"; do
        local binary
        binary=$(crate_binary "$tool")

        if ! command -v "$binary" &>/dev/null; then
            log_info "Installing cargo tool: $tool"
            cargo install --locked "$tool" || log_warn "Failed: $tool"
        fi
    done

    log_success "Cargo layer complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
