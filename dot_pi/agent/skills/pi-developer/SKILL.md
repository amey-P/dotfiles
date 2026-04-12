---
name: pi-developer
description: "Create, test, and improve skills, extensions, and agents for the Pi coding agent. Use when users want to build custom skills, develop extensions, create specialized agents, or optimize existing Pi capabilities. Follow this skill's process: understand intent → draft → test → evaluate → improve → repeat."
---

# Pi Developer Skill

Create, test, and improve skills, extensions, and agents for the Pi coding agent.

## The Core Loop

1. **Understand intent** - What should this capability do?
2. **Draft** - Write the skill/extension/agent
3. **Test** - Run with realistic test cases
4. **Evaluate** - Review results, both qualitatively and quantitatively
5. **Improve** - Refine based on feedback
6. **Repeat** - Iterate until satisfied

Be flexible — the user may want just a quick draft, or full evaluation with benchmarks.

---

## Creating a Skill

### Step 1: Capture Intent

Start by understanding what the user wants. If they have an existing workflow, extract:
- The tools used
- The sequence of steps
- Input/output formats
- Corrections they made

Ask if needed:
1. What should this skill enable Pi to do?
2. When should it trigger? (what phrases/contexts)
3. What's the expected output format?
4. Should we create test cases to verify it works?

### Step 2: Write the SKILL.md

```markdown
---
name: my-skill
description: "What this skill does AND specific contexts when to use it.
  Make descriptions slightly 'pushy' to improve triggering.
  Include both task types AND triggering phrases."
compatibility: "Required tools, dependencies (optional)"
---

# My Skill

## Overview
Brief description of what this skill does.

## Quick Reference
Short reference table for common operations.

## Detailed Instructions

### Section 1
Explain with examples.

### Section 2
More details with code samples.

## Output Format
Define how results should be structured.
```

### Skill Anatomy

```
my-skill/
├── SKILL.md              # Required: frontmatter + instructions
├── scripts/              # Executable helpers
│   └── process.sh
├── references/          # Additional docs loaded on-demand
│   └── api-guide.md
├── examples/            # Example outputs
│   └── sample.md
└── evals/               # Test cases (optional)
    └── evals.json
```

### Progressive Disclosure

Three loading levels:
1. **Metadata** (~100 words) - name + description always in context
2. **SKILL.md body** (<500 lines) - loaded when skill triggers
3. **Bundled resources** - scripts/executables loaded as needed

### Writing Patterns

**Output formats:**
```markdown
## Output Structure
ALWAYS use this template:
# [Title]
## Summary
## Details
```

**Examples:**
```markdown
**Example:**
Input: User request
Output: Expected response format
```

**Tool instructions:**
```markdown
## File Operations
\`\`\`bash
./scripts/process.sh <input>
\`\`\`
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | 1-64 chars, lowercase, hyphens only |
| `description` | Yes | Max 1024 chars. Include triggering contexts |
| `license` | No | License name |
| `compatibility` | No | Required tools, dependencies |

---

## Creating an Extension

### Minimal Extension

```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";

export default function (pi: ExtensionAPI) {
  // Register tools
  pi.registerTool({
    name: "my_tool",
    label: "My Tool",
    description: "What this tool does",
    parameters: Type.Object({
      input: Type.String(),
    }),
    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return { content: [{ type: "text", text: `Result: ${params.input}` }] };
    },
  });

  // Register commands
  pi.registerCommand("hello", {
    description: "Say hello",
    handler: async (args, ctx) => {
      ctx.ui.notify(`Hello ${args || "world"}!`, "info");
    },
  });

  // Subscribe to events
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.notify("Extension loaded!", "info");
  });
}
```

### Extension Locations

```
~/.pi/agent/extensions/          # Global
.p.i/extensions/                  # Project-local
```

### Key Imports

```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
```

### Event Lifecycle

```
session_start → before_agent_start → agent_start
  → message_start → message_update → message_end
  → tool_execution_start → tool_call → tool_result → tool_execution_end
  → turn_start → turn_end → agent_end
```

### Common Events

| Event | Purpose |
|-------|---------|
| `session_start` | Initialize on load |
| `before_agent_start` | Modify prompt, inject messages |
| `tool_call` | Block/modify tool calls |
| `tool_result` | Modify tool results |
| `session_shutdown` | Cleanup on exit |

### Tool Blocking Example

```typescript
pi.on("tool_call", async (event, ctx) => {
  if (isToolCallEventType("bash", event)) {
    if (event.input.command.includes("rm -rf")) {
      const ok = await ctx.ui.confirm("Dangerous!", "Allow rm -rf?");
      if (!ok) return { block: true, reason: "Blocked by user" };
    }
  }
});
```

### UI Interaction

```typescript
// Select, confirm, input, notify
const choice = await ctx.ui.select("Pick one:", ["A", "B", "C"]);
const ok = await ctx.ui.confirm("Delete?", "This cannot be undone");
const name = await ctx.ui.input("Name:", "placeholder");
ctx.ui.notify("Done!", "success");

// Status and widgets
ctx.ui.setStatus("my-ext", "Processing...");
ctx.ui.setWidget("my-widget", ["Line 1"]);
```

---

## Creating an Agent

Agents are specialized AI assistants defined as markdown files.

### Agent Locations

```
~/.pi/agent/agents/              # User-level (global)
.p.i/agents/                      # Project-level
```

### Agent File Format

**Important:** Do NOT specify `model` or `tools` in the frontmatter. Agents inherit both from the parent session by default.

```markdown
---
name: my-agent
description: "What this agent does and when to use it"
---

You are a specialized AI assistant.

## Your Role
Describe your specialized role.

## Strategy
1. First step
2. Second step
3. Third step

## Output Format
Define your output format.
```

### Agent Frontmatter

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier (lowercase, hyphens) |
| `description` | Yes | When to use this agent |
| `tools` | No | `read`, `bash`, `edit`, `write`, `grep`, `find`, `ls` |
| `model` | No | Specific model (provider/id) |

### Invoking Agents (subagent tool)

```typescript
// Single mode
{ agent: "reviewer", task: "Review auth module" }

// Parallel mode
{ tasks: [
  { agent: "scout", task: "Explore codebase" },
  { agent: "planner", task: "Create plan" }
] }

// Chain mode (sequential with {previous} placeholder)
{ chain: [
  { agent: "scout", task: "Explore {previous}" },
  { agent: "planner", task: "Plan based on findings" }
] }
```

---

## Testing Skills

### Create Test Cases

Save to `evals/evals.json`:

```json
{
  "skill_name": "my-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's realistic task prompt",
      "expected_output": "Description of expected result",
      "files": [],
      "expectations": [
        "The output includes X",
        "The skill used approach Y"
      ]
    }
  ]
}
```

### Test Prompt Guidelines

Good test prompts are:
- **Realistic** - Like what a user would actually type
- **Specific** - Include file paths, context, details
- **Substantive** - Complex enough that the skill helps

Bad: `"Format this data"`, `"Create a chart"`

Good: `"My boss sent me Q4-sales-final.xlsx and wants a column showing profit margin as %. Revenue is col C, costs in col D."`

### Run Tests

```bash
# Quick test
pi -e ./my-extension.ts

# Skill discovery
pi --skill ~/.pi/agent/skills/my-skill

# Reload all
/reload
```

### Evaluate Results

For each test case:
1. Run with skill
2. Run baseline (without skill)
3. Compare outputs
4. Check against expectations

---

## Evaluation Framework

### Grading Criteria

**PASS when:**
- Evidence clearly demonstrates the expectation
- Specific quotes or findings support the verdict
- The work reflects genuine task completion

**FAIL when:**
- No evidence found
- Evidence contradicts expectation
- Output superficially satisfies but doesn't actually work

### Grading Output Format

```json
{
  "expectations": [
    {
      "text": "The output includes X",
      "passed": true,
      "evidence": "Found in Step 3: 'Result: X'"
    }
  ],
  "summary": {
    "passed": 1,
    "failed": 0,
    "total": 1,
    "pass_rate": 1.0
  },
  "claims": [
    {
      "claim": "The output has correct format",
      "type": "factual",
      "verified": true,
      "evidence": "File contains # Title header"
    }
  ]
}
```

### Metrics to Track

| Metric | What it measures |
|--------|------------------|
| pass_rate | % of expectations met |
| execution_time | How long it took |
| token_usage | Cost efficiency |
| tool_calls | Complexity of execution |

---

## Improving Skills

Based on evaluation feedback:

1. **Generalize** - Don't overfit to specific examples
2. **Keep lean** - Remove things that don't pull their weight
3. **Explain why** - Help the model understand the reasoning
4. **Bundle helpers** - If scripts are written repeatedly, add them to `scripts/`

### The Iteration Loop

1. Apply improvements
2. Rerun test cases
3. Compare to previous iteration
4. Review with user
5. Repeat until satisfied

---

## Reference

### Quick Reference Tables

**Extension Locations:**
| Location | Scope |
|----------|-------|
| `~/.pi/agent/extensions/` | Global |
| `.pi/extensions/` | Project |

**Skill Locations:**
| Location | Scope |
|----------|-------|
| `~/.pi/agent/skills/` | Global |
| `.pi/skills/` | Project |

**Agent Locations:**
| Location | Scope |
|----------|-------|
| `~/.pi/agent/agents/` | User |
| `.pi/agents/` | Project |

### Key Scripts

| Script | Purpose |
|--------|---------|
| `./scripts/new-extension.sh` | Create extension boilerplate |
| `./scripts/new-skill.sh` | Create skill boilerplate |
| `./scripts/new-agent.sh` | Create agent boilerplate |

### Useful Commands

| Command | Description |
|---------|-------------|
| `/reload` | Reload extensions, skills, themes |
| `/model` | Switch model |
| `/new` | New session |
| `/compact` | Compact conversation |

---

## References

- [Extension Docs](https://www.mintlify.com/badlogic/pi-mono/coding-agent/extensions)
- [Skills Spec](https://agentskills.io/specification)
- [pi-ext by tomsej](https://github.com/tomsej/pi-ext)
- [Example Extensions](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/examples/extensions)
- [Claude Skill Creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator) - Gold standard reference
