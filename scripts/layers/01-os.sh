#!/bin/bash
# Layer 1: OS package manager installations
# Installs fundamental tools via the system's package manager

set -uo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/logger.sh
source "$SOURCE_DIR/lib/logger.sh"
# shellcheck source=../lib/detection.sh
source "$SOURCE_DIR/lib/detection.sh"
# shellcheck source=../lib/state.sh
source "$SOURCE_DIR/lib/state.sh"

main() {
    local pkg_mgr
    pkg_mgr=$(detect_package_manager)
    
    log_section "Layer 1: OS Packages"
    log_info "Package manager: $pkg_mgr"
    
    step "os-packages" || return $?
    
    local sudo
    sudo=$(get_privilege_cmd)
    
    case "$pkg_mgr" in
        apt)
            $sudo apt update || log_warn "apt update failed"
            $sudo apt install -y \
                git stow curl gcc cmake libssl-dev pkg-config luarocks \
                vim emacs universal-ctags tmux zsh nodejs \
                ripgrep neofetch fzf neovim yazi fd-find
            ;;
        pacman)
            $sudo pacman -Syu --noconfirm \
                git stow curl gcc cmake openssl pkg-config luarocks \
                vim emacs ctags tmux zsh nodejs \
                ripgrep neofetch fzf neovim yazi
            ;;
        brew)
            brew install \
                git curl gcc cmake vim emacs neovim tmux zsh \
                node ripgrep bat fd fzf exa
            ;;
        pkg)
            $sudo pkg update || true
            $sudo pkg install -y \
                git curl gcc cmake vim neovim tmux zsh \
                nodejs ripgrep fzf fd bat
            ;;
        none)
            log_warn "No package manager detected"
            log_info "Install manually: git, curl, gcc, make, tmux, zsh, neovim, ripgrep, fzf"
            return 0
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
