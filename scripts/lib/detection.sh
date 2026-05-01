#!/bin/bash
# OS and distribution detection

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "linux-android"* ]]; then
        echo "termux"
    else
        echo "unknown"
    fi
}

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        echo "${ID:-unknown}"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

detect_package_manager() {
    local os=$(detect_os)
    local distro=$(detect_distro)
    
    case "$os" in
        darwin)
            if command -v brew &>/dev/null; then
                echo "brew"
            else
                echo "none"
            fi
            ;;
        linux)
            case "$distro" in
                ubuntu|debian|pop|linuxmint)
                    echo "apt"
                    ;;
                arch|manjaro|endeavouros)
                    echo "pacman"
                    ;;
                fedora|rhel|centos)
                    if command -v dnf &>/dev/null; then
                        echo "dnf"
                    else
                        echo "yum"
                    fi
                    ;;
                alpine)
                    echo "apk"
                    ;;
                termux)
                    echo "pkg"
                    ;;
                *)
                    echo "none"
                    ;;
            esac
            ;;
        termux)
            echo "pkg"
            ;;
        *)
            echo "none"
            ;;
    esac
}

detect_arch() {
    uname -m
}

# Print system info
print_system_info() {
    log_info "Operating System: $(detect_os)"
    log_info "Distribution: $(detect_distro)"
    log_info "Package Manager: $(detect_package_manager)"
    log_info "Architecture: $(detect_arch)"
    log_info "Home Directory: $HOME"
    log_info "Shell: ${SHELL##*/}"
}

# Check if running as root/sudo
is_root() {
    [[ $EUID -eq 0 ]]
}

# Check if sudo is available
has_sudo() {
    command -v sudo &>/dev/null || command -v doas &>/dev/null
}

# Get privilege escalation command
get_privilege_cmd() {
    if is_root; then
        echo ""
    elif has_sudo; then
        if command -v sudo &>/dev/null; then
            echo "sudo"
        else
            echo "doas"
        fi
    else
        echo ""
    fi
}

# Export functions
export -f detect_os detect_distro detect_package_manager detect_arch
export -f print_system_info is_root has_sudo get_privilege_cmd
