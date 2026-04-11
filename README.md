# dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/). Supports Linux (Debian/Ubuntu, Arch), macOS, and Termux (Android).

## Quick Start

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Apply dotfiles on a new machine
chezmoi init --apply git@github.com:amey-P/dotfiles.git

# Transfer the age encryption key (required for secrets)
# Copy ~/.config/chezmoi/key.txt from another machine
```

## Structure

```
dotfiles/
├── .chezmoidata.yaml              # Per-platform package lists and data
├── .chezmoiexternal.toml          # External deps (Oh My Zsh, TPM, vim-plug)
├── .chezmoiignore                  # Platform-specific exclusions
├── .chezmoiscripts/                # Idempotent install scripts
│   ├── run_onchange_after_install-packages.sh.tmpl  # apt/pacman/brew/pkg
│   ├── run_once_after_install-rust.sh.tmpl         # rustup + cargo tools
│   ├── run_once_after_install-fonts.sh.tmpl         # Nerd font (Linux/macOS)
│   ├── run_once_after_install-fzf.sh.tmpl          # FZF from git
│   ├── run_once_after_install-luarocks.sh           # Build from source
│   └── run_once_after_setup-zsh.sh                  # chsh -s zsh
├── dot_zshrc.tmpl                  # Zsh config (template: Linux/macOS/Termux)
├── dot_emacs                       # Emacs config
├── dot_Xmodmap                     # X11 key remap (Linux only)
├── dot_vimrc                       # Vim config
├── dot_vim/                        # Vim colors, ftplugin
├── dot_config/
│   ├── nvim/                        # Neovim + lazy.nvim
│   ├── tmux/tmux.conf              # Tmux config
│   ├── gitui/                       # GitUI keys + theme
│   ├── yazi/keymap.toml             # Yazi file manager
│   └── opencode/opencode.jsonc     # OpenCode config
└── encrypted_dot_config.zsh.age   # Age-encrypted secrets
```

## Platform Support

| Feature | Debian/Ubuntu | Arch | macOS | Termux |
|---------|:---:|:---:|:---:|:---:|
| Package install | apt | pacman | brew | pkg |
| Zsh config | Full | Full | Full | Minimal |
| Tmux auto-attach | Yes | Yes | Yes | No |
| Xmodmap (Caps→Esc) | Yes | Yes | No | No |
| Conda init | No | No | No | No |
| FZF | apt + git | pacman + git | brew | pkg + git |
| Nerd font | Yes | Yes | Yes | No |
| Cargo tools | Yes | Yes | Limited | No |

## Secrets

Secrets are encrypted with [age](https://age-encryption.org/). The encrypted file `encrypted_dot_config.zsh.age` decrypts to `~/.config.zsh` at apply time.

The encryption key is at `~/.config/chezmoi/key.txt`. **Back it up securely** — without it, secrets are unrecoverable. Transfer it to new machines manually.

To edit secrets:
```bash
chezmoi edit ~/.config.zsh
```

## Manual Steps

These require manual installation (not managed by chezmoi):

- **Age key transfer**: Copy `~/.config/chezmoi/key.txt` between machines.

## Common Commands

```bash
chezmoi diff              # Preview changes before applying
chezmoi apply             # Apply all changes
chezmoi edit ~/.zshrc     # Edit a config file (opens editor)
chezmoi add ~/.newfile    # Add a new file to management
chezmoi update            # Pull remote changes and apply
chezmoi cd                # Open shell in source directory
chezmoi data              # View template variables (OS, hostname, etc.)
```

## Adding a New Config

```bash
chezmoi add ~/.config/newapp/config.toml     # Add as regular file
chezmoi add --template ~/.config/app/rc      # Add as template
chezmoi add --encrypt ~/.secret               # Encrypt with age
```

## Template Variables

The `.zshrc` template uses these chezmoi variables:

- `.chezmoi.os` — `linux`, `darwin`
- `.chezmoi.osRelease.id` — `ubuntu`, `debian`, `arch`
- `.chezmoi.hostname` — machine hostname

Data from `.chezmoidata.yaml`:

- `.packages.apt` / `.packages.pacman` / `.packages.brew` / `.packages.termux`
- `.cargo_tools`