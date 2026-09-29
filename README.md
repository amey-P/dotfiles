# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/), which also installs the packages and tools they need (there is a legacy shell installer under `scripts/` as well). Supports Linux (Debian/Ubuntu, Arch), macOS, and Termux (Android).

## Quick Start

One command on a fresh machine. It installs chezmoi, clones this repo, installs
packages and tools, and applies the configs:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply amey-P/dotfiles
```

- The chezmoi binary lands in `./bin/chezmoi`. Install it system-wide with
  `brew install chezmoi` (or your package manager) if you want it on `PATH`.
- Use `--ssh` after `--apply` to clone over SSH instead of HTTPS.
- Needs `curl` and `git` already present. `git` is not installed for you.
- Already have chezmoi? `chezmoi init --apply amey-P/dotfiles`.
- Later: `chezmoi update` pulls and applies; `chezmoi diff` previews changes.

### Legacy installer

```bash
git clone https://github.com/amey-P/dotfiles.git ~/dotfiles
~/dotfiles/scripts/install.sh          # add --tui for the interactive front-end
```

## What Gets Installed

| Category | Components |
|----------|------------|
| **Shell** | Zsh, Oh My Zsh |
| **Editor** | Neovim, Emacs |
| **Tools** | herdr, FZF, fd, bat, ripgrep, GitUI, Yazi |
| **Fonts** | Nerd Font (DroidSansMono) |
| **Agents** | pi, claude-code |

## Structure

The repo holds two independent systems, and `.chezmoiroot` keeps them apart:
everything chezmoi manages lives under `home/`, and nothing outside it is ever
written to your home directory.

```
dotfiles/
├── .chezmoiroot                 # contains "home" — chezmoi's source root
├── install                      # bootstrap: clone repo, hand off to installer
├── scripts/                     # installation — never applied to $HOME
│   ├── install.sh               # orchestrator + CLI
│   ├── tui.py                   # optional ncurses front-end
│   ├── layers/                  # installation layers, run in order
│   │   ├── 01-os.sh             # system packages
│   │   ├── 02-cargo.sh          # Rust/Cargo tools
│   │   ├── 03-npm.sh            # NPM global packages
│   │   └── 04-config.sh         # hands off to chezmoi
│   └── lib/                     # shared libraries
│       ├── logger.sh            # logging
│       ├── detection.sh         # OS/distro/package-manager detection
│       ├── state.sh             # sentinel-based state tracking
│       └── packages.sh          # reads package lists from .chezmoidata.yaml
│
└── home/                        # chezmoi source state — applied to $HOME
    ├── .chezmoidata.yaml        # ← single source of truth for package lists
    ├── .chezmoiexternal.toml    # oh-my-zsh, vim-plug
    ├── .chezmoiignore           # target-path exclusions (see note below)
    ├── .chezmoi.toml.tmpl       # age encryption config
    ├── .chezmoiscripts/         # apply-time hooks (fonts, fzf, chsh)
    ├── dot_zshrc.tmpl           # ~/.zshrc (templated)
    ├── dot_vimrc, dot_emacs, dot_Xmodmap, dot_vim/
    ├── dot_config/              # ~/.config
    │   ├── nvim/                # Neovim + lazy.nvim
    │   ├── zsh/                 # numbered fragments sourced by ~/.zshrc
    │   ├── gitui/  yazi/
    │   └── symlink_pi.tmpl      # ~/.config/pi → ~/.pi/agent
    ├── dot_pi/                  # ~/.pi — pi agent config, skills, agents
    └── encrypted_dot_config.zsh.age
```

### Who installs what

Package installation belongs to `scripts/layers/`. `home/.chezmoiscripts/` holds
only the apply-time work no layer performs:

| Script | Why it is not a layer |
|--------|-----------------------|
| `20-install-fonts` | Needs to run on any machine that applies configs |
| `20-install-fzf` | Produces `~/.fzf.zsh`, which `dot_config/zsh/06-tools.zsh` sources and the packaged fzf does not create |
| `90-setup-zsh` | `chsh` to zsh |

### A note on `.chezmoiignore`

Its patterns match **target** paths (`.config/nvim/plugin/`), not source-state
names (`dot_config/nvim/plugin/`). Patterns written in source form are silently
ignored and do nothing. Paths supplied by `.chezmoiexternal.toml` must not be
listed there — ignoring them prevents the external from installing at all.

## Package Lists

`home/.chezmoidata.yaml` is the only place package lists are defined. The
installer layers read it through `read_list` in `scripts/lib/packages.sh`:

```bash
source scripts/lib/packages.sh
read_list packages.apt        # one item per line
read_list cargo_tools
read_list npm_global
```

Keys are `packages.{apt,pacman,brew,pkg}` — matching what `detect_package_manager`
returns — plus the flat lists `cargo_tools` and `npm_global`. Anything cargo can install lives in `cargo_tools` only; herdr is installed by its upstream script in `01-os.sh`.
To add a tool, edit that file and nothing else.

## Chezmoi-only Install

Chezmoi can do everything the installer layers do, with no dependency on `scripts/`.
The install steps are `run_onchange_before_*` scripts in `home/.chezmoiscripts/`,
templated over the same `.chezmoidata.yaml` lists. Each reruns only when its own
list changes.

This is the same flow as the one-liner in [Quick Start](#quick-start).

| Script | Does |
|--------|------|
| `10-os-packages` | `packages.<manager>` via apt/pacman/brew/pkg (manager picked by `.chezmoitemplates/pkgmgr`) |
| `20-rustup` | rustup (not on Termux) |
| `30-cargo-tools` | `cargo_tools` not already in `cargo install --list` |
| `40-npm-globals` | `npm_global` + `~/.pi/agent/*` dirs |
| `50-herdr` | herdr upstream installer |

| Installer | Chezmoi |
|-----------|---------|
| `--dry-run` | `chezmoi apply --dry-run --verbose` |
| `--force <layer>` | `chezmoi state delete-bucket --bucket=scriptState`, then `chezmoi apply` |
| `--list` | `chezmoi state dump` |
| `--skip` / TUI | no equivalent |

## Installation Layers

Installation happens in 4 ordered layers:

| Layer | Description | Package Manager |
|-------|-------------|-----------------|
| **os** | System packages (zsh, neovim, emacs, fzf, node) + herdr | apt/pacman/brew/pkg |
| **cargo** | Rust toolchain + tools (fd, bat, ripgrep, gitui, yazi) | cargo |
| **npm** | NPM global packages (pi, claude-code) | npm |
| **config** | Dotfile configuration via chezmoi | chezmoi |

## Installation Options

```bash
# Full installation (all layers)
./scripts/install.sh

# Dry run (preview)
./scripts/install.sh --dry-run

# Verbose/debug output
./scripts/install.sh --verbose
./scripts/install.sh --debug

# Skip a layer
./scripts/install.sh --skip os          # Skip system packages
./scripts/install.sh --skip cargo       # Skip Rust tools

# Force rerun a layer
./scripts/install.sh --force npm        # Force NPM reinstall

# Reset all state
./scripts/install.sh --reset

# List completed layers
./scripts/install.sh --list

# Run only installation layers (no config)
./scripts/install.sh --layers-only

# Run only configuration layer
./scripts/install.sh --config-only

# ncurses TUI (optional: pip install blessed, else CLI fallback)
./scripts/install.sh --tui
```

## State & Resume

The installer tracks completed layers in `~/.local/state/dotfiles/`. If the installation fails, simply re-run and it will resume from where it left off.

```bash
# View completed layers
./scripts/install.sh --list

# Force rerun a failed layer
./scripts/install.sh --force cargo
```

## Self-Healing

Installation layers are idempotent:
- Package installation: `apt install` is idempotent, skips already-installed packages
- Cargo tools: Installs only missing tools
- NPM packages: Skips already-installed packages

If a layer fails, fix the issue and re-run — the installer won't redo successful layers.

## Platform Support

| Feature | Debian/Ubuntu | Arch | macOS | Termux |
|---------|:---:|:---:|:---:|:---:|
| Package install | apt | pacman | brew | pkg |
| Rust/Cargo | Yes | Yes | Yes | No |
| Nerd fonts | Yes | Yes | Yes | No |
| Xmodmap | Yes | Yes | No | No |

## Chezmoi Commands

After installation, use chezmoi directly for config management:

```bash
chezmoi diff              # Preview changes
chezmoi apply             # Apply all changes
chezmoi update            # Pull remote changes + apply
chezmoi edit ~/.zshrc     # Edit a config file
chezmoi cd                # Open shell in source directory (lands in home/)
chezmoi managed           # List everything chezmoi would write
```

## Secrets Management

Secrets are encrypted with [age](https://age-encryption.org/). The encrypted file `home/encrypted_dot_config.zsh.age` decrypts to `~/.config.zsh` at apply time, and `home/dot_pi/agent/encrypted_private_auth.json.age` to `~/.pi/agent/auth.json`.

**Backup your key:**
```bash
~/.config/chezmoi/key.txt   # Keep this safe!
```

Transfer to new machines:
```bash
scp other-machine:~/.config/chezmoi/key.txt ~/.config/chezmoi/key.txt
```

## Adding New Configs

```bash
# Add to chezmoi management (lands under home/ automatically)
chezmoi add ~/.config/newapp/config.toml

# Add as template (for machine-specific values)
chezmoi add --template ~/.config/app/rc

# Encrypt a secret
chezmoi add --encrypt ~/.secret
```
