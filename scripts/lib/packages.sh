#!/bin/bash
# Reads package lists out of home/.chezmoidata.yaml.
#
# That file is the single source of truth for what the installer installs, and
# it stays in chezmoi's native data format so templates can reach it too. This
# parser is deliberately narrow: it understands only the shape that file uses —
# two levels of keys, plain scalar list items, optionally double/single quoted.
# It is not a general YAML parser, and adding a `yq` dependency to bootstrap a
# machine that has no packages yet would be backwards.

_PKG_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DATA_FILE="${PKG_DATA_FILE:-$_PKG_LIB_DIR/../../home/.chezmoidata.yaml}"

# read_list <dotted.key> — prints one item per line.
#   read_list npm_global
#   read_list packages.apt
# Prints nothing (exit 0) for a key that has no list, so callers can treat an
# absent platform as "nothing to install" rather than an error.
read_list() {
    local want="$1"

    if [[ ! -f "$PKG_DATA_FILE" ]]; then
        echo "packages.sh: data file not found: $PKG_DATA_FILE" >&2
        return 1
    fi

    awk -v want="$want" '
        { sub(/\r$/, "") }
        /^[[:space:]]*#/ { next }
        /^[[:space:]]*$/ { next }

        # top-level key, e.g. "packages:" or "npm_global:"
        /^[A-Za-z_][A-Za-z0-9_-]*:/ {
            top = $0
            sub(/:.*$/, "", top)
            path = top
            next
        }

        # nested key, e.g. "  apt:"
        /^[[:space:]]+[A-Za-z_][A-Za-z0-9_-]*:[[:space:]]*$/ {
            sub2 = $0
            sub(/^[[:space:]]+/, "", sub2)
            sub(/:[[:space:]]*$/, "", sub2)
            path = top "." sub2
            next
        }

        # list item, e.g. "    - git"
        /^[[:space:]]*-[[:space:]]+/ {
            if (path != want) next
            v = $0
            sub(/^[[:space:]]*-[[:space:]]+/, "", v)
            sub(/[[:space:]]+$/, "", v)
            gsub(/^[\047"]|[\047"]$/, "", v)
            if (v != "") print v
        }
    ' "$PKG_DATA_FILE"
}

export -f read_list
