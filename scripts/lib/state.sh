#!/bin/bash
# State management for resumable installations

# State directory
STATE_DIR="${STATE_DIR:-$HOME/.local/state/dotfiles}"
mkdir -p "$STATE_DIR"

# Sentinel file helpers
sentinel_create() {
    local name="$1"
    local sentinel="$STATE_DIR/${name}.done"
    touch "$sentinel"
    log_debug "Created sentinel: $sentinel"
}

sentinel_exists() {
    local name="$1"
    local sentinel="$STATE_DIR/${name}.done"
    [[ -f "$sentinel" ]]
}

sentinel_remove() {
    local name="$1"
    local sentinel="$STATE_DIR/${name}.done"
    rm -f "$sentinel"
    log_debug "Removed sentinel: $sentinel"
}

sentinel_mark() {
    local name="$1"
    local sentinel="$STATE_DIR/${name}.done"
    mkdir -p "$(dirname "$sentinel")"
    echo "$(date -Iseconds)" > "$sentinel"
}

sentinel_timestamp() {
    local name="$1"
    local sentinel="$STATE_DIR/${name}.done"
    if [[ -f "$sentinel" ]]; then
        cat "$sentinel"
    fi
}

# Run a step only if sentinel doesn't exist (idempotent)
run_once() {
    local name="$1"
    local command="$2"
    
    if sentinel_exists "$name"; then
        log_debug "Skipping '$name' (already completed)"
        return 1
    fi
    
    log_step "Running: $name"
    if eval "$command"; then
        sentinel_mark "$name"
        return 0
    else
        log_warn "Command failed: $name"
        return 1
    fi
}

# Run a step only if sentinel doesn't exist
run_once_or_skip() {
    local name="$1"
    shift
    local command="$*"
    
    if sentinel_exists "$name"; then
        log_debug "Skipping '$name' (already completed)"
        return 1
    fi
    
    log_step "Running: $name"
    if "$@"; then
        sentinel_mark "$name"
        return 0
    else
        log_warn "Command failed: $name"
        return 1
    fi
}

# Force rerun a step (removes sentinel first)
force_rerun() {
    local name="$1"
    shift
    local command="$*"
    
    sentinel_remove "$name"
    "$@"
    sentinel_mark "$name"
}

# List all sentinels
list_sentinels() {
    echo "Completed steps:"
    if [[ -d "$STATE_DIR" ]]; then
        for f in "$STATE_DIR"/*.done; do
            if [[ -f "$f" ]]; then
                local name="${f%.done}"
                name="${name##*/}"
                local ts=$(cat "$f" 2>/dev/null || echo "unknown")
                echo "  $name: $ts"
            fi
        done
    else
        echo "  (none)"
    fi
}

# Reset all state (clean slate)
reset_state() {
    log_warn "Removing all installation state..."
    rm -rf "$STATE_DIR"
    mkdir -p "$STATE_DIR"
    log_success "State reset complete"
}

# Skip/force specific steps
SKIP_STEPS="${SKIP_STEPS:-}"
FORCE_STEPS="${FORCE_STEPS:-}"

should_skip() {
    local name="$1"
    for skip in $SKIP_STEPS; do
        [[ "$skip" == "$name" ]] && return 0
    done
    return 1
}

should_force() {
    local name="$1"
    for force in $FORCE_STEPS; do
        [[ "$force" == "$name" ]] && return 0
    done
    return 1
}

# Wrapper for step execution with skip/force support
step() {
    local name="$1"
    shift
    local command="$*"
    
    # Check skip list
    if should_skip "$name"; then
        log_info "Skipping (--skip): $name"
        return 0
    fi
    
    # Check force list
    if should_force "$name"; then
        log_info "Forcing (--force): $name"
        sentinel_remove "$name"
    fi
    
    # Check if already done
    if sentinel_exists "$name"; then
        log_info "Skipping (already done): $name"
        return 0
    fi
    
    # Execute
    log_step "Running: $name"
    if "$@"; then
        sentinel_mark "$name"
        return 0
    else
        local exit=$?
        log_error "Failed: $name (exit code: $exit)"
        return $exit
    fi
}

# Export functions
export -f sentinel_create sentinel_exists sentinel_remove sentinel_mark sentinel_timestamp
export -f run_once run_once_or_skip force_rerun list_sentinels reset_state
export -f should_skip should_force step
