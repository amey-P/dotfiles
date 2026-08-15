#!/bin/bash
# Pi Agent Boilerplate Generator
# Usage: ./new-agent.sh <agent-name> [--scope user|project]

set -e

NAME="${1:-my-agent}"
SCOPE="${2:-user}"

# Validate name: lowercase, hyphens only
if ! [[ "$NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Error: Invalid agent name. Use lowercase letters, numbers, and hyphens only."
  exit 1
fi

# Determine directory
if [ "$SCOPE" = "project" ]; then
  AGENTS_DIR="$(pwd)/.pi/agents"
else
  AGENTS_DIR="$HOME/.pi/agent/agents"
fi

mkdir -p "$AGENTS_DIR"
FILE="$AGENTS_DIR/${NAME}.md"

if [ -f "$FILE" ]; then
  echo "Error: Agent '$NAME' already exists at $FILE"
  exit 1
fi

cat > "$FILE" << EOF
---
name: $NAME
description: "Describe what this agent does and when to use it"
tools: read, bash
---

You are a specialized AI assistant.

## Your Role
Describe your specialized role here.

## Capabilities
- Capability 1
- Capability 2

## Strategy
1. First step
2. Second step
3. Third step

## Output Format
Describe how to format your output.
EOF

echo "Created agent at: $FILE"
echo ""
echo "Edit the file to customize your agent:"
echo "  - Set 'description' for when to use"
echo "  - Add 'tools' (read, bash, edit, write, grep, find, ls)"
echo "  - Optionally set 'model' (e.g., claude-sonnet-4-5)"
echo "  - Write your system prompt below frontmatter"
echo ""
echo "To use:"
echo "  /subagent agent='$NAME' task='your task'"
