#!/bin/bash
# Pi Skill Test Runner
# Usage: ./run-tests.sh <skill-name>

set -e

SKILL_NAME="${1:-}"
WORKSPACE_DIR="$HOME/.pi/agent/skills/pi-developer/workspace"

if [ -z "$SKILL_NAME" ]; then
  echo "Usage: $0 <skill-name>"
  echo ""
  echo "Runs test cases defined in the skill's evals/ directory."
  echo ""
  echo "Creates results in: $WORKSPACE_DIR/iteration-N/"
  exit 1
fi

SKILL_PATH="$HOME/.pi/agent/skills/$SKILL_NAME"
EVALS_FILE="$SKILL_PATH/evals/evals.json"

if [ ! -f "$EVALS_FILE" ]; then
  echo "Error: No evals file found at $EVALS_FILE"
  exit 1
fi

# Count existing iterations
ITERATION=1
while [ -d "$WORKSPACE_DIR/iteration-$ITERATION" ]; do
  ITERATION=$((ITERATION + 1))
done

echo "Starting iteration $ITERATION"
echo "Skill: $SKILL_NAME"
echo "Results: $WORKSPACE_DIR/iteration-$ITERATION"
echo ""
echo "Test cases found:"
jq -r '.evals[] | "  - [\(.id)] \(.prompt | head -c 60)..."' "$EVALS_FILE" 2>/dev/null || echo "  (Could not parse evals file)"
echo ""
echo "To run tests:"
echo "  1. Start pi with the skill loaded"
echo "  2. Run each test prompt manually"
echo "  3. Save results to $WORKSPACE_DIR/iteration-$ITERATION/eval-N/"
echo ""
echo "See $WORKSPACE_DIR/README.md for the full workflow"
