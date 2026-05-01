#!/bin/bash
# Layer 4: Configuration unpacking
# Applies dotfile configurations via chezmoi

set -uo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/logger.sh
source "$SOURCE_DIR/lib/logger.sh"
# shellcheck source=../lib/detection.sh
source "$SOURCE_DIR/lib/detection.sh"
# shellcheck source=../lib/state.sh
source "$SOURCE_DIR/lib/state.sh"

main() {
    log_section "Layer 4: Configuration"
    
    # Install chezmoi if needed
    if ! command -v chezmoi &>/dev/null; then
        step "chezmoi-install" || return $?
        log_info "Installing chezmoi..."
        sh -c "$(curl -fsLS get.chezmoi.io)" || {
            log_error "Failed to install chezmoi"
            return 1
        }
    else
        sentinel_mark "chezmoi-install"
        log_info "chezmoi already installed"
    fi
    
    # Apply configurations
    step "chezmoi-apply" || return $?
    
    local repo="git@github.com:amey-P/dotfiles.git"
    log_info "Applying dotfiles from $repo"
    echo ""
    
    chezmoi init "$repo" --apply --verbose || {
        log_error "chezmoi apply failed"
        return 1
    }
    
    log_success "Configuration layer complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
