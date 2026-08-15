#!/bin/bash
# Pi Skill Boilerplate Generator
# Usage: ./new-skill.sh <skill-name>

set -e

NAME="${1:-my-skill}"

# Validate name: lowercase, hyphens only, no consecutive hyphens
if ! [[ "$NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Error: Invalid skill name. Use lowercase letters, numbers, and hyphens only."
  exit 1
fi

DIR="$HOME/.pi/agent/skills/$NAME"

if [ -d "$DIR" ]; then
  echo "Error: Skill '$NAME' already exists at $DIR"
  exit 1
fi

mkdir -p "$DIR/scripts" "$DIR/references"

cat > "$DIR/SKILL.md" << EOF
---
name: $NAME
description: "Describe what this skill does and when to use it. Be specific about use cases."
---

# $NAME Skill

## Setup

Run once before first use:
\`\`\`bash
cd /path/to/$NAME
# Add setup commands here
\`\`\`

## Usage

Describe how to use this skill:
\`\`\`bash
./scripts/run.sh <input>
\`\`\`

## Examples

### Basic Example
\`\`\`bash
./scripts/run.sh example
\`\`\`

## Notes

- Important caveats
- Known limitations
- Troubleshooting tips
EOF

cat > "$DIR/scripts/run.sh" << 'EOF'
#!/bin/bash
# Add your skill logic here
echo "Skill executed with: $1"
EOF

chmod +x "$DIR/scripts/run.sh"

echo "Created skill at: $DIR"
echo ""
echo "The skill is auto-discovered from: $DIR/SKILL.md"
echo ""
echo "To use:"
echo "  /skill:$NAME"
echo "  /skill:$NAME arg1 arg2"
