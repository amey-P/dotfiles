# dotfiles

Personal dotfiles managed with a custom installer + [chezmoi](https://www.chezmoi.io/) for configuration. Supports Linux (Debian/Ubuntu, Arch), macOS, and Termux (Android).

## Quick Start

```bash
# Clone the repo
git clone git@github.com:amey-P/dotfiles.git ~/dotfiles

# Run the installer
~/dotfiles/scripts/install.sh

# Or pipe directly
sh -c "$(curl -fsSL https://raw.githubusercontent.com/amey-P/dotfiles/main/scripts/install.sh)"
```

## What Gets Installed

| Category | Components |
|----------|------------|
| **Shell** | Zsh, Oh My Zsh |
| **Editor** | Neovim, Vim, Emacs |
| **Tools** | Tmux, FZF, GitUI, Yazi, Cargo tools |
| **Fonts** | Nerd Font (DroidSansMono) |
| **Pi** | pi-coding-agent, npm globals |

## Structure

```
dotfiles/
├── scripts/                     # Installation scripts
│   ├── install.sh              # Main orchestrator
│   ├── layers/                 # Installation layers (in order)
│   │   ├── 01-os.sh           # System packages
│   │   ├── 02-cargo.sh       # Rust/Cargo tools
│   │   ├── 03-npm.sh          # NPM global packages
│   │   └── 04-config.sh       # Chezmoi configuration
│   └── lib/                    # Shared libraries
│       ├── logger.sh           # Logging utilities
│       ├── detection.sh        # OS/distro detection
│       └── state.sh            # State tracking (sentinels)
│
├── chezmoi/                     # Chezmoi source state
│   ├── dot_zshrc.tmpl          # Zsh config (templated)
│   ├── dot_config/             # Config directory
│   │   ├── nvim/               # Neovim + lazy.nvim
│   │   ├── tmux/               # Tmux config
│   │   ├── gitui/              # GitUI keys + theme
│   │   ├── yazi/               # Yazi keybindings
│   │   └── opencode/           # OpenCode config
│   └── ...                     # Other dotfiles
│
├── chezmoi.toml                # Chezmoi configuration
├── .chezmoidata.yaml           # Template data (packages, etc.)
├── .chezmoiexternal.toml       # External deps
├── .chezmoiignore              # Platform exclusions
└── encrypted_dot_config.zsh.age # Encrypted secrets
```

## Installation Layers

Installation happens in 4 ordered layers:

| Layer | Description | Package Manager |
|-------|-------------|-----------------|
| **os** | System packages (git, zsh, neovim, tmux, etc.) | apt/pacman/brew/pkg |
| **cargo** | Rust toolchain + tools (eza, bat, zoxide, etc.) | cargo |
| **npm** | NPM global packages (pi-coding-agent, etc.) | npm |
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
| Tmux auto-attach | Yes | Yes | Yes | No |
| Xmodmap | Yes | Yes | No | No |

## Chezmoi Commands

After installation, use chezmoi directly for config management:

```bash
chezmoi diff              # Preview changes
chezmoi apply             # Apply all changes
chezmoi update            # Pull remote changes + apply
chezmoi edit ~/.zshrc     # Edit a config file
chezmoi cd                # Open shell in source directory
```

## Secrets Management

Secrets are encrypted with [age](https://age-encryption.org/). The encrypted file `encrypted_dot_config.zsh.age` decrypts to `~/.config.zsh` at apply time.

**Backup your key:**
```bash
~/.config/chezmoi/key.txt   # Keep this safe!
```

Transfer to new machines:
```bash
scp other-machine:~/.config/chezmoi/key.txt ~/.config/chezmoi/key.txt
```

## Directory Separation

| Layer | Responsibility |
|-------|---------------|
| **scripts/** | Installation, dependencies, tools |
| **chezmoi/** | Configuration, symlinks, templates, secrets |

This separation means:
- You can run installations independently from config updates
- chezmoi stays focused on config management
- Resume after failures without reinstalling everything

## Adding New Configs

```bash
# Add to chezmoi management
chezmoi add ~/.config/newapp/config.toml

# Add as template (for machine-specific values)
chezmoi add --template ~/.config/app/rc

# Encrypt a secret
chezmoi add --encrypt ~/.secret
```
