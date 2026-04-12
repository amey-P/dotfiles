# Pi Agent Creation Guide

Agents are specialized AI assistants defined as markdown files. They can be invoked via the `subagent` tool in single, parallel, or chain modes.

## Quick Reference

### Agent File Format

```markdown
---
name: agent-name
description: "What this agent does and when to use it"
tools: read, bash, grep, find, ls
model: claude-sonnet-4-5
---

You are a [specialized role].

## Your Role
Describe your specialization and expertise.

## Strategy
1. First step
2. Second step
3. Third step

## Output Format
Define how to structure results.
```

### Agent Locations

| Location | Scope | Use Case |
|----------|-------|----------|
| `~/.pi/agent/agents/` | User | Personal agents, global |
| `.pi/agents/` | Project | Team agents, repo-specific |

### Tool Selection

| Tools | Best For |
|-------|----------|
| `read` only | Analysis, review |
| `read, grep, find` | Research, exploration |
| `read, bash` | Code review (read-only commands) |
| `read, bash, edit, write` | Full development tasks |

---

## Creating Effective Agents

### Writing the System Prompt

**Be specific about role:**
```markdown
You are a senior code reviewer specializing in security.
You have 10 years of experience finding vulnerabilities.
```

**Define clear strategy:**
```markdown
## Review Strategy
1. Check for SQL injection vulnerabilities
2. Look for XSS issues
3. Verify authentication flows
```

**Specify output format:**
```markdown
## Output Format
## Critical Issues
- `file:line` - Issue with fix
## Summary
[2-3 sentence assessment]
```

### Description Optimization

Descriptions determine when agents trigger. Be specific:

**Too vague:**
```yaml
description: "Code reviewer"
```

**Better:**
```yaml
description: "Senior code reviewer for quality, security, and best practices. Use when reviewing pull requests, checking code quality, or identifying bugs."
```

### Tool Selection

Only enable necessary tools:
- `read` - Always useful for understanding
- `grep, find` - For searching without editing
- `bash` - Only for read-only commands (git diff, etc.)
- `edit, write` - Only if the agent should modify files

---

## Invoking Agents

### Single Mode
```typescript
{
  agent: "reviewer",
  task: "Review the auth module for security issues"
}
```

### Parallel Mode
```typescript
{
  tasks: [
    { agent: "scout", task: "Explore the codebase structure" },
    { agent: "planner", task: "Plan the refactor" },
    { agent: "reviewer", task: "Review test coverage" }
  ]
}
```

### Chain Mode
```typescript
{
  chain: [
    { agent: "scout", task: "Explore the codebase" },
    { agent: "planner", task: "Create plan based on findings: {previous}" },
    { agent: "worker", task: "Implement the plan" }
  ]
}
```

---

## Testing Agents

### Quick Test
```bash
# In pi
> Use the subagent tool to invoke "my-agent" with task "test task"
```

### Subagent Options

| Option | Default | Description |
|--------|---------|-------------|
| `agentScope` | `"user"` | Which dirs to search (`user`, `project`, `both`) |
| `cwd` | (current) | Working directory for the agent |
| `confirmProjectAgents` | `true` | Prompt before running project agents |

---

## Example Agents

### Code Reviewer
```markdown
---
name: reviewer
description: "Senior code reviewer for quality and security analysis"
tools: read, grep, find, ls, bash
model: claude-sonnet-4-5
---

You are a senior code reviewer with expertise in:
- Bug detection
- Security vulnerabilities
- Code quality
- Performance issues

## Review Strategy
1. Run `git diff` to see changes
2. Read modified files
3. Analyze for issues

## Output Format
## Critical (must fix)
- `file:line` - Issue description

## Summary
2-3 sentence assessment.
```

### Researcher
```markdown
---
name: researcher
description: "Explore codebase and gather information"
tools: read, grep, find, ls
---

You are a code researcher. Explore thoroughly and cite specific files.

## Research Strategy
1. Understand structure
2. Find relevant files
3. Trace dependencies
4. Document findings

## Output Format
## Project Structure
Brief overview.

## Key Components
| Component | File | Purpose |
```
### Planner
```markdown
---
name: planner
description: "Break down complex tasks into actionable steps"
tools: read, ls, bash
---

You are a task planner. Create clear, actionable plans.

## Planning Process
1. Understand the goal
2. Identify constraints
3. Sequence dependencies
4. Estimate effort

## Output Format
## Task Summary
One paragraph.

## Implementation Plan
| Step | Action | Files | Effort |
```
---

## Debugging

### Agent Not Found
- Check file location: `~/.pi/agent/agents/` or `.pi/agents/`
- Verify frontmatter has `name` and `description`
- Reload pi: `/reload`

### Wrong Output Format
- Review the system prompt for clarity
- Add explicit format instructions
- Test with simpler inputs first

### Tool Permission Issues
- Verify tool list in frontmatter
- Check if tools are blocked by policy
- Consider using read-only tools
