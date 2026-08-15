#!/bin/bash
# Pi Extension Boilerplate Generator
# Usage: ./new-extension.sh <extension-name>

set -e

NAME="${1:-my-extension}"
DIR="$HOME/.pi/agent/extensions/$NAME"

if [ -d "$DIR" ]; then
  echo "Error: Extension '$NAME' already exists at $DIR"
  exit 1
fi

mkdir -p "$DIR/src"

cat > "$DIR/src/index.ts" << 'EOF'
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";

export default function (pi: ExtensionAPI) {
  // Initialize on session start
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.notify("Extension loaded!", "info");
  });

  // Register a tool
  pi.registerTool({
    name: "my_tool",
    label: "My Tool",
    description: "Describe what this tool does",
    parameters: Type.Object({
      input: Type.String({ description: "Input description" }),
    }),
    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return {
        content: [{ type: "text", text: `Result: ${params.input}` }],
        details: {},
      };
    },
  });

  // Register a command
  pi.registerCommand("hello", {
    description: "Say hello",
    handler: async (args, ctx) => {
      ctx.ui.notify(`Hello ${args || "world"}!`, "info");
    },
  });
}
EOF

echo "Created extension at: $DIR"
echo ""
echo "To test:"
echo "  pi -e $DIR/src/index.ts"
echo ""
echo "Or move to extensions directory for auto-discovery:"
echo "  mv $DIR/src/index.ts ~/.pi/agent/extensions/"
