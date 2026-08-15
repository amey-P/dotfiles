# Pi & OpenCode Setup

## Overview

This directory manages configuration for two AI coding agents:
- **pi** - `@mariozechner/pi-coding-agent`
- **opencode** - `opencode-ai`

## Directory Structure

```
dot_pi/agent/           # pi configuration
├── settings.json        # pi settings (packages, thinking level, model)
├── AGENTS.md           # global agent instructions
├── skills/             # pi skills (agent-developer, extension-developer, etc.)
├── agents/             # custom agents
├── extensions/         # pi extensions directory
└── encrypted_private_auth.json.age  # encrypted auth

dot_config/
├── opencode/           # opencode configuration
│   ├── opencode.jsonc  # opencode config
│   └── skills/         # opencode skills (implement, refinery, etc.)
└── pi/                 # pi symlink target (~/.config/pi → ~/.pi/agent)
```

## Installation

### NPM Packages

```bash
npm install -g @mariozechner/pi-coding-agent
npm install -g @tintinweb/pi-subagents
npm install -g @imsus/pi-extension-minimax-coding-plan-mcp
```

### Pi Extensions

The following extensions are configured in `settings.json`:

```json
{
  "packages": [
    "npm:@imsus/pi-extension-minimax-coding-plan-mcp",
    "npm:@tintinweb/pi-subagents"
  ]
}
```

These provide:
- MiniMax MCP tools (web search, image understanding)
- Subagent helpers

#### Manual Extension Installation

For some extensions, additional setup may be needed:

```bash
# If extension needs compiled binaries or additional tools
# Check extension documentation for specific requirements
```

## Skill Locations

| Tool | Global Skills | Project Skills |
|------|---------------|----------------|
| pi | `~/.pi/agent/skills/` | `.pi/skills/` |
| opencode | `~/.config/opencode/skills/` | `.opencode/skills/` |

## Extension Locations

| Tool | Global Extensions | Project Extensions |
|------|------------------|-------------------|
| pi | `~/.pi/agent/extensions/` | `.pi/extensions/` |
| opencode | N/A | N/A |

## Termux Notes

On Termux (Android):
- Node is installed via `pkg install nodejs`
- nvm may not work due to Android restrictions
- Use Termux-specific npm prefix if needed
- Some extensions may have platform limitations

## Auth Setup

Private auth is stored encrypted with age:
- `dot_pi/agent/encrypted_private_auth.json.age` → decrypts to auth config
- Key file: `~/.config/chezmoi/key.txt` (transfer manually between machines)

## Key Files

- `~/.pi/agent/settings.json` - pi settings
- `~/.pi/agent/auth.json` - API keys (keep secure)
- `~/.pi/agent/AGENTS.md` - agent behavior instructions
- `~/.config/opencode/opencode.jsonc` - opencode config