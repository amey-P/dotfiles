# JSON Schemas for Pi Skill Development

## evals.json

Defines test cases for a skill. Located at `evals/evals.json` within the skill directory.

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's example prompt - be specific with context",
      "expected_output": "Description of expected result",
      "files": ["evals/files/sample1.md"],
      "expectations": [
        "The output includes X",
        "The skill used script Y",
        "The format matches requirements"
      ]
    }
  ]
}
```

**Fields:**
- `skill_name`: Name matching the skill's frontmatter
- `evals[].id`: Unique integer identifier
- `evals[].prompt`: The task to execute
- `evals[].expected_output`: Human-readable description of success
- `evals[].files`: Optional list of input file paths (relative to skill root)
- `evals[].expectations`: List of verifiable statements

---

## grading.json

Output from evaluating a test case. Located at `<run-dir>/grading.json`.

```json
{
  "expectations": [
    {
      "text": "The output includes the name 'John'",
      "passed": true,
      "evidence": "Found in transcript: 'Extracted: John, Sarah'"
    },
    {
      "text": "The spreadsheet has correct headers",
      "passed": false,
      "evidence": "Output is plain text, expected CSV with headers"
    }
  ],
  "summary": {
    "passed": 1,
    "failed": 1,
    "total": 2,
    "pass_rate": 0.5
  },
  "execution_metrics": {
    "tool_calls": {
      "Read": 5,
      "Write": 2,
      "Bash": 8
    },
    "total_tool_calls": 15,
    "total_steps": 6,
    "errors_encountered": 0,
    "output_chars": 12450
  },
  "timing": {
    "duration_ms": 23332,
    "total_duration_seconds": 23.3
  },
  "claims": [
    {
      "claim": "The output is a valid markdown file",
      "type": "factual",
      "verified": true,
      "evidence": "File starts with # header and contains markdown formatting"
    }
  ],
  "eval_feedback": {
    "suggestions": [
      {
        "assertion": "The format matches requirements",
        "reason": "This assertion is too vague - specify exact format expected"
      }
    ],
    "overall": "Core functionality works, format assertion needs clarification"
  }
}
```

**Fields:**
- `expectations[]`: Graded expectations with evidence
- `summary`: Aggregate pass/fail counts
- `execution_metrics`: Tool usage and output size
- `timing`: Wall clock timing
- `claims`: Extracted and verified claims
- `eval_feedback`: Improvement suggestions (only when warranted)

---

## Test Case Best Practices

### Writing Good Prompts

**Good prompts are:**
- Specific with context and details
- Realistic (like what users actually type)
- Substantive (complex enough the skill helps)

**Bad:** `"Format this data"`, `"Create a chart"`

**Good:** `"My boss sent Q4-sales.xlsx (revenue in col C, costs in D). She wants a profit margin column as %. Make it professional for the board meeting."`

### Writing Good Assertions

**Good assertions:**
- Objectively verifiable
- Check both existence AND correctness
- Discriminating (pass when skill succeeds, fail when it doesn't)

**Bad:** `"The file exists"` (passes even if empty)

**Good:** `"The file contains a markdown table with 3 columns and at least 5 rows"`

### Test Case Organization

```
my-skill/
├── SKILL.md
├── evals/
│   ├── evals.json           # Test definitions
│   └── files/               # Input files
│       └── sample.pdf
├── results/                 # Test results
│   └── iteration-1/
│       ├── eval-1/
│       │   ├── with_skill/
│       │   └── without_skill/
│       └── grading.json
└── workspace/               # Working directory
```

---

## Running Tests

### Manual Testing

```bash
# Test a skill
pi --skill ~/.pi/agent/skills/my-skill
> [test prompt]

# Test an extension
pi -e ./my-extension.ts
```

### Automated Testing

For CI/CD, use the SDK:

```typescript
import { createAgentSession, SessionManager } from "@mariozechner/pi-coding-agent";

const { session } = await createAgentSession({
  sessionManager: SessionManager.inMemory(),
});

session.subscribe((event) => {
  if (event.type === "agent_end") {
    // Check results
  }
});

await session.prompt("[test prompt]");
```

---

## Evaluation Workflow

1. **Create test cases** in `evals/evals.json`
2. **Run with skill**: Execute each test prompt with the skill loaded
3. **Run baseline**: Execute same prompts without the skill
4. **Compare results**: Check outputs against expectations
5. **Grade**: Record pass/fail for each expectation
6. **Review**: Present results to user for feedback
7. **Improve**: Refine skill based on evaluation
8. **Repeat**: Iterate until satisfied
