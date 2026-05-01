#!/bin/bash
# Layer 3: NPM global packages
# Installs Node.js global tools

set -uo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/logger.sh
source "$SOURCE_DIR/lib/logger.sh"
# shellcheck source=../lib/detection.sh
source "$SOURCE_DIR/lib/detection.sh"
# shellcheck source=../lib/state.sh
source "$SOURCE_DIR/lib/state.sh"

main() {
    log_section "Layer 3: NPM Packages"
    
    if ! command -v npm &>/dev/null; then
        log_warn "npm not found, skipping NPM layer"
        return 0
    fi
    
    step "npm-packages" || return $?
    
    local packages=(
        "@mariozechner/pi-coding-agent"
        "@anthropic-ai/claude-code"
        "opencode-ai"
    )
    
    for pkg in "${packages[@]}"; do
        if npm list -g "$pkg" &>/dev/null; then
            log_debug "Already installed: $pkg"
        else
            log_info "Installing: $pkg"
            npm install -g "$pkg" 2>/dev/null || log_warn "Failed: $pkg"
        fi
    done
    
    # Setup pi directories
    step "pi-dirs" || return $?
    mkdir -p "$HOME/.pi/agent/skills" \
             "$HOME/.pi/agent/agents" \
             "$HOME/.pi/agent/extensions" \
             "$HOME/.local/state/dotfiles"
    
    log_success "NPM layer complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
