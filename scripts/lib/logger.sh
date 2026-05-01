#!/bin/bash
# Logging utilities for dotfiles installation

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color
readonly BOLD='\033[1m'

# Log levels
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_SUCCESS=2
readonly LOG_LEVEL_WARN=3
readonly LOG_LEVEL_ERROR=4

# Default to INFO
: "${LOG_LEVEL:=$LOG_LEVEL_INFO}"

log() {
    local level=$1
    shift
    local msg="$*"
    
    if [[ $level -lt $LOG_LEVEL ]]; then
        return
    fi
    
    local color=""
    local prefix=""
    case $level in
        $LOG_LEVEL_DEBUG)   color="$BLUE";   prefix="DEBUG" ;;
        $LOG_LEVEL_INFO)    color="$CYAN";   prefix="INFO" ;;
        $LOG_LEVEL_SUCCESS) color="$GREEN";  prefix="OK" ;;
        $LOG_LEVEL_WARN)    color="$YELLOW";  prefix="WARN" ;;
        $LOG_LEVEL_ERROR)   color="$RED";    prefix="ERROR" ;;
    esac
    
    echo -e "${color}[${prefix}]${NC} $msg"
}

log_debug()  { log $LOG_LEVEL_DEBUG "$@"; }
log_info()   { log $LOG_LEVEL_INFO "$@"; }
log_success(){ log $LOG_LEVEL_SUCCESS "$@"; }
log_warn()   { log $LOG_LEVEL_WARN "$@"; }
log_error()  { log $LOG_LEVEL_ERROR "$@" >&2; }

# Section headers
log_section() {
    echo ""
    echo -e "${BOLD}${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BOLD}${BLUE}  $*${NC}"
    echo -e "${BOLD}${BLUE}═══════════════════════════════════════════${NC}"
    echo ""
}

# Progress indicator
log_step() {
    echo -e "${CYAN}  → $*${NC}"
}

# Success with checkmark
log_done() {
    echo -e "${GREEN}  ✓ $*${NC}"
}

# Failure with X
log_fail() {
    echo -e "${RED}  ✗ $*${NC}"
}

# Confirm prompt
confirm() {
    local prompt="${1:-Continue?}"
    local default="${2:-n}"
    
    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]"
    else
        prompt="$prompt [y/N]"
    fi
    
    while true; do
        echo -ne "$prompt: "
        read -r yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            "")    [[ "$default" == "y" ]] && return 0 || return 1 ;;
            *)     echo "Please answer y or n." ;;
        esac
    done
}

# Dry run mode
DRY_RUN="${DRY_RUN:-false}"
dry_run() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_debug "[DRY RUN] $*"
        return 0
    fi
    return 1
}

# Export functions
export -f log_debug log_info log_success log_warn log_error
export -f log_section log_step log_done log_fail confirm dry_run
