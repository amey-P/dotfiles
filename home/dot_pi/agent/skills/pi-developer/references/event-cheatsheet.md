# Pi Extension Event Cheatsheet

## Lifecycle Overview

```
pi starts
  │
  ├─► session_start { reason: "startup" }
  └─► resources_discover { reason: "startup" }
      │
      ▼
user sends prompt ─────────────────────────────────────────┐
  │                                                        │
  ├─► input (can intercept, transform, or handle)          │
  ├─► before_agent_start (can inject message)              │
  ├─► agent_start                                          │
  │                                                        │
  │   ┌─── turn (repeats while LLM calls tools) ───┐      │
  │   │                                            │       │
  │   ├─► turn_start                               │       │
  │   ├─► context (can modify messages)           │       │
  │   │                                            │       │
  │   │   LLM responds, may call tools:            │       │
  │   │     ├─► tool_execution_start               │       │
  │   │     ├─► tool_call (can block)             │       │
  │   │     ├─► tool_result (can modify)          │       │
  │   │     └─► tool_execution_end                 │       │
  │   │                                            │       │
  │   └─► turn_end                                 │       │
  │                                                        │
  └─► agent_end                                            │
                                                           │
user sends another prompt ◄────────────────────────────────┘
```

---

## Session Events

### session_start
Fired when session starts/loads/reloads.

```typescript
pi.on("session_start", async (event, ctx) => {
  // event.reason: "startup" | "reload" | "new" | "resume" | "fork"
  ctx.ui.notify(`Session: ${event.reason}`, "info");
});
```

### session_shutdown
Fired on exit (Ctrl+C, Ctrl+D, SIGTERM).

```typescript
pi.on("session_shutdown", async (_event, ctx) => {
  // Cleanup: close connections, save state
});
```

### session_before_switch / session_before_fork
Fired before session changes.

```typescript
pi.on("session_before_switch", async (event, ctx) => {
  return { cancel: true }; // Cancel the switch
});
```

---

## Agent Events

### before_agent_start
Fired after user submits, before agent loop.

```typescript
pi.on("before_agent_start", async (event, ctx) => {
  return {
    message: {
      customType: "my-extension",
      content: "Additional context",
      display: true,
    },
    systemPrompt: event.systemPrompt + "\n\nExtra...",
  };
});
```

### agent_start / agent_end
Fired once per user prompt.

```typescript
pi.on("agent_start", async (_event, ctx) => {});
pi.on("agent_end", async (event, ctx) => {
  // event.messages - messages from this prompt
});
```

---

## Turn Events

### turn_start / turn_end
Fired for each turn (one LLM response + tool calls).

```typescript
pi.on("turn_start", async (event, ctx) => {
  // event.turnIndex, event.timestamp
});

pi.on("turn_end", async (event, ctx) => {
  // event.message, event.toolResults
});
```

---

## Tool Events

### tool_call
Fired before tool execution. **Can block.**

```typescript
pi.on("tool_call", async (event, ctx) => {
  // event.toolName, event.toolCallId
  // event.input - mutable!

  if (isToolCallEventType("bash", event)) {
    if (event.input.command.includes("rm -rf")) {
      const ok = await ctx.ui.confirm("Dangerous!", "Allow?");
      if (!ok) return { block: true, reason: "Blocked" };
    }
  }
});
```

### tool_result
Fired after execution, before result display. **Can modify.**

```typescript
pi.on("tool_result", async (event, ctx) => {
  // event.toolName, event.toolCallId
  // event.content, event.details, event.isError

  return { content: [...], details: {...} }; // Modify result
});
```

---

## Input Events

### input
Fired when user input received.

```typescript
pi.on("input", async (event, ctx) => {
  // event.text - raw input
  // event.source: "interactive" | "rpc" | "extension"

  return { action: "continue" };     // Default
  return { action: "transform", text: "New text" };
  return { action: "handled" };         // Skip agent
});
```

---

## Type Guards

```typescript
import { isToolCallEventType, isBashToolResult } from "@mariozechner/pi-coding-agent";

if (isToolCallEventType("bash", event)) {
  // event.input is { command: string; timeout?: number }
}

if (isBashToolResult(event)) {
  // event.details is BashToolDetails
}
```

---

## Event Return Values

| Event | Return Type | Purpose |
|-------|-------------|---------|
| `tool_call` | `{ block?: boolean; reason?: string }` | Block/modify tool |
| `tool_result` | `{ content?, details?, isError? }` | Modify result |
| `input` | `{ action: "continue" \| "transform" \| "handled" }` | Control input |
| `before_agent_start` | `{ message?, systemPrompt? }` | Inject content |
| `session_before_switch` | `{ cancel?: boolean }` | Control session switch |

---

## Quick Examples

### Permission Gate
```typescript
pi.on("tool_call", async (event, ctx) => {
  if (isToolCallEventType("bash", event)) {
    if (event.input.command.match(/rm\s+-rf|drop\s+database/i)) {
      const ok = await ctx.ui.confirm("Dangerous!", "Continue?");
      if (!ok) return { block: true, reason: "User declined" };
    }
  }
});
```

### Logging
```typescript
pi.on("tool_result", async (event, ctx) => {
  if (isToolCallEventType("bash", event)) {
    console.log(`Bash result: ${event.content}`);
  }
});
```

### Context Injection
```typescript
pi.on("before_agent_start", async (event, ctx) => {
  const branch = ctx.sessionManager.getBranch();
  return {
    message: {
      customType: "my-ext",
      content: `Session has ${branch.length} entries`,
      display: true,
    },
  };
});
```
