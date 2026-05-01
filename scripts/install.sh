#!/bin/bash
# Dotfiles installation orchestrator
# Runs installation layers in dependency order

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source libraries
# shellcheck source=lib/logger.sh
source "$SCRIPT_DIR/lib/logger.sh"
# shellcheck source=lib/detection.sh
source "$SCRIPT_DIR/lib/detection.sh"
# shellcheck source=lib/state.sh
source "$SCRIPT_DIR/lib/state.sh"

export STATE_DIR="${STATE_DIR:-$HOME/.local/state/dotfiles}"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

usage() {
    cat << EOF
dotfiles installation

Usage: $(basename "$0") [OPTIONS]

OPTIONS:
    -h, --help          Show this help
    -n, --dry-run       Preview actions without doing them
    -v, --verbose       Verbose output
    -d, --debug         Debug output
    -l, --list          List completed layers
    -r, --reset         Reset all state (start fresh)
    -f, --force LAYER   Force rerun a layer
    -s, --skip LAYER    Skip a layer
    --layers-only       Run only installation layers (skip config)
    --config-only       Run only configuration layer

LAYERS:
    os      - System packages (apt/pacman/brew/pkg)
    cargo   - Rust toolchain and tools
    npm     - NPM global packages
    config  - Chezmoi dotfile configuration

EXAMPLES:
    $(basename "$0")                    # Full installation
    $(basename "$0") --dry-run         # Preview
    $(basename "$0") -f cargo          # Force rerun cargo layer
    $(basename "$0") --skip os         # Skip OS packages
    $(basename "$0") --reset            # Start fresh

EOF
}

# Parse arguments
SKIP_STEPS=""
FORCE_STEPS=""
LAYERS_ONLY=""
CONFIG_ONLY=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage; exit 0 ;;
        -n|--dry-run) export DRY_RUN="true"; export LOG_LEVEL="$LOG_LEVEL_DEBUG" ;;
        -v|--verbose) export LOG_LEVEL="$LOG_LEVEL_INFO" ;;
        -d|--debug) export LOG_LEVEL="$LOG_LEVEL_DEBUG" ;;
        -l|--list) list_sentinels; exit 0 ;;
        -r|--reset) reset_state; exit 0 ;;
        -f|--force) FORCE_STEPS="$FORCE_STEPS $2"; shift ;;
        -s|--skip) SKIP_STEPS="$SKIP_STEPS $2"; shift ;;
        --layers-only) LAYERS_ONLY="true" ;;
        --config-only) CONFIG_ONLY="true" ;;
        *) log_error "Unknown option: $1"; usage; exit 1 ;;
    esac
    shift
done

export SKIP_STEPS
export FORCE_STEPS

# ---------------------------------------------------------------------------
# Layer runner
# ---------------------------------------------------------------------------

run_layer() {
    local name="$1"
    local script="$2"
    
    if should_skip "$name"; then
        log_info "Skipping: $name"
        return 0
    fi
    
    if should_force "$name"; then
        log_info "Forcing: $name"
        sentinel_remove "$name"
    fi
    
    if sentinel_exists "$name"; then
        log_info "Done: $name"
        return 0
    fi
    
    if [[ ! -f "$script" ]]; then
        log_warn "Script not found: $script"
        return 0
    fi
    
    log_step "Running: $name"
    
    if bash "$script"; then
        sentinel_mark "$name"
        log_done "Completed: $name"
        return 0
    else
        log_fail "Failed: $name"
        return 1
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
    log_section "Dotfiles Installation"
    print_system_info
    
    # Config only mode
    if [[ "$CONFIG_ONLY" == "true" ]]; then
        run_layer "config" "$SCRIPT_DIR/layers/04-config.sh"
        exit $?
    fi
    
    # Layers
    run_layer "os" "$SCRIPT_DIR/layers/01-os.sh"
    run_layer "cargo" "$SCRIPT_DIR/layers/02-cargo.sh"
    run_layer "npm" "$SCRIPT_DIR/layers/03-npm.sh"
    
    # Config layer
    if [[ "$LAYERS_ONLY" != "true" ]]; then
        run_layer "config" "$SCRIPT_DIR/layers/04-config.sh"
    fi
    
    # Summary
    log_section "Installation Complete"
    echo ""
    log_info "Completed layers:"
    list_sentinels | grep -v "^$" | sed 's/^/  /'
    echo ""
    log_info "Next steps:"
    log_info "  exec \$SHELL     # Restart shell"
    log_info "  chezmoi diff    # Preview config changes"
    log_info "  chezmoi update  # Sync with remote"
}

main "$@"
