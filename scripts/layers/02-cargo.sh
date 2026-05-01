#!/bin/bash
# Layer 2: Cargo/Rust toolchain and tools
# Installs rustup and cargo binaries

set -uo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/logger.sh
source "$SOURCE_DIR/lib/logger.sh"
# shellcheck source=../lib/detection.sh
source "$SOURCE_DIR/lib/detection.sh"
# shellcheck source=../lib/state.sh
source "$SOURCE_DIR/lib/state.sh"

# shellcheck source=/dev/null
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

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
    
    # Install cargo tools
    step "cargo-tools" || return $?
    
    # Tools by OS
    local tools_common=(eza bat zoxide macchina)
    local tools_linux=(nu fd-find)
    local tools_darwin=(nu)
    
    local tools=("${tools_common[@]}")
    [[ "$os" == "linux" ]] && tools+=("${tools_linux[@]}")
    [[ "$os" == "darwin" ]] && tools+=("${tools_darwin[@]}")
    
    # Install missing tools
    for tool in "${tools[@]}"; do
        local binary="$tool"
        [[ "$tool" == "fd-find" ]] && binary="fd"
        
        if ! command -v "$binary" &>/dev/null; then
            log_info "Installing cargo tool: $tool"
            cargo install --locked "$tool" 2>/dev/null || log_warn "Failed: $tool"
        fi
    done
    
    # Fix fd symlink
    if command -v fd-find &>/dev/null && [[ ! -L "$HOME/.cargo/bin/fd" ]]; then
        ln -sf "$HOME/.cargo/bin/fd-find" "$HOME/.cargo/bin/fd"
    fi
    
    log_success "Cargo layer complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
