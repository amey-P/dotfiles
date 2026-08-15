# Pi Developer Skill - Test Workspace

This directory is used for testing and iterating on skills.

## Directory Structure

```
workspace/
├── iteration-1/              # First iteration
│   ├── eval-1/               # Test case 1
│   │   ├── with_skill/       # Output with skill
│   │   ├── without_skill/    # Baseline output
│   │   └── grading.json      # Evaluation results
│   ├── eval-2/
│   │   └── ...
│   └── benchmark.json         # Aggregated results
├── iteration-2/
│   └── ...
└── feedback.json             # User feedback
```

## Running Tests

### 1. Create test cases in skill's evals/ directory

```json
{
  "skill_name": "my-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "Realistic test prompt",
      "expected_output": "What success looks like",
      "expectations": ["The output includes X"]
    }
  ]
}
```

### 2. Run evaluation

For each test case:
1. Run with the skill loaded
2. Run without the skill (baseline)
3. Grade results against expectations
4. Save to grading.json

### 3. Aggregate results

Create benchmark.json with pass rates, timing, and token usage.

### 4. Get feedback

Present results to user for review and improvement suggestions.

## Quick Test Commands

```bash
# Test extension
pi -e ./my-extension.ts

# Test skill
pi --skill ~/.pi/agent/skills/my-skill

# Reload all
/reload
```

## Grading Template

```json
{
  "expectations": [
    { "text": "Expectation", "passed": true, "evidence": "Found in output" }
  ],
  "summary": { "passed": 1, "failed": 0, "total": 1, "pass_rate": 1.0 }
}
```
