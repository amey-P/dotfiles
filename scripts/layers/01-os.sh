#!/bin/bash
# Layer 1: OS package manager installations
# Installs fundamental tools via the system's package manager.
# Package lists live in home/.chezmoidata.yaml, not here.

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

install_pip_packages() {
    local pip_pkgs
    mapfile -t pip_pkgs < <(read_list "pip_packages")
    [[ ${#pip_pkgs[@]} -eq 0 ]] && return 0

    local pip_user="--user"
    # Homebrew python installs into a user-writable prefix already.
    [[ "$(detect_os)" == "darwin" ]] && pip_user=""

    log_info "Installing pip packages: ${pip_pkgs[*]}"
    # shellcheck disable=SC2086
    pip3 install $pip_user "${pip_pkgs[@]}" 2>/dev/null \
        || log_warn "pip install failed (TUI will fall back to CLI mode)"
}

main() {
    local pkg_mgr
    pkg_mgr=$(detect_package_manager)

    log_section "Layer 1: OS Packages"
    log_info "Package manager: $pkg_mgr"

    step "os-packages" || return $?

    local packages
    mapfile -t packages < <(read_list "packages.$pkg_mgr")

    if [[ ${#packages[@]} -eq 0 ]]; then
        log_warn "No package list defined for '$pkg_mgr' in $PKG_DATA_FILE"
        log_info "Install manually: git, curl, gcc, cmake, tmux, zsh, neovim, ripgrep, fzf, python3"
        return 0
    fi

    log_info "Installing ${#packages[@]} packages"

    local sudo
    sudo=$(get_privilege_cmd)

    case "$pkg_mgr" in
        apt)
            $sudo apt update || log_warn "apt update failed"
            $sudo apt install -y "${packages[@]}"
            ;;
        pacman)
            $sudo pacman -Syu --noconfirm "${packages[@]}"
            ;;
        brew)
            brew install "${packages[@]}"
            ;;
        pkg)
            $sudo pkg update || true
            $sudo pkg install -y "${packages[@]}"
            ;;
        *)
            log_warn "Unsupported package manager: $pkg_mgr"
            return 0
            ;;
    esac

    install_pip_packages
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
