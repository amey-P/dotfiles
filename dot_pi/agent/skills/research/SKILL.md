---
name: research
description: "Comprehensive research skill for thorough investigation with citations. Use when users ask about deep research, multiple perspectives, in-depth analysis, or thorough investigation. Triggers on: 'research', 'investigate', 'find out', 'comprehensive analysis', 'thorough look', 'deep dive', 'continuous research', 'keep researching', 'spawn more agents'."
compatibility: "web_search, understand_image"
---

# Research Skill

Conduct thorough, well-cited research by spawning subagents for breadth and depth. Supports both one-shot and continuous iterative research modes.

## Quick Start

| Mode | Command | Use When |
|------|---------|----------|
| **Single** | `research [topic]` | One-off investigation, clear question |
| **Continuous** | `research [topic], keep going` | Complex topics, emerging clarity, multiple waves needed |

## Research Modes

### Mode 1: Single-Shot Research
Use when the question is well-defined and bounded:
- "What are the GST requirements for Indian e-commerce?"
- "How does WhatsApp Business work for D2C brands?"
- "What are the margins in Indian distribution business?"

### Mode 2: Continuous Research (Recommended for Complex Topics)
Use when:
- The topic has multiple interconnected aspects
- Findings from one wave reveal new areas to explore
- Initial research raises more questions than answers
- The goal is not fully clear yet — clarity emerges through exploration

**The Continuous Research Loop:**
```
Wave 1 → Findings + New Questions → Wave 2 → Deeper Findings + More Questions → Wave N → Synthesis
```

**When to Continue:**
- Open questions remain unanswered
- Findings suggest unexplored angles
- Initial assumptions were wrong or incomplete
- The goal itself evolved based on findings
- New areas of opportunity/risks identified

## Wave Architecture

### Wave Structure
Each wave spawns parallel subagents to cover different angles. Findings from a wave feed into the next.

```bash
# Wave N: Spawn parallel agents for breadth
{ agent: "researcher", task: "Research [angle 1]", run_in_background: true }
{ agent: "researcher", task: "Research [angle 2]", run_in_background: true }
{ agent: "researcher", task: "Research [angle 3]", run_in_background: true }
```

### Wave-to-Wave Handoffs
After each wave, synthesize findings and identify:

1. **Confirmed facts** — Move to evidence base
2. **New questions raised** — Queue for next wave
3. **Assumptions to validate** — Flag for verification
4. **Gaps in coverage** — Flag for exploration
5. **Shifts in goal clarity** — Note if research is redirecting

### Typical Wave Count by Topic Complexity

| Complexity | Waves | Subagents/Wave | Total Subagents |
|------------|-------|----------------|-----------------|
| Simple | 1-2 | 2-3 | 4-6 |
| Medium | 2-3 | 3-5 | 9-15 |
| Complex | 3-5 | 4-6 | 16-30 |
| Very Complex | 5+ | 5-8 | 25+ |

## Subagent Instructions

### For Each Subagent
Give clear, focused tasks that:
1. Cover a specific angle or aspect
2. Include output format requirements
3. Specify citation needs
4. Flag what to look for AND what to flag as "needs more research"

### Parallel Spawning Pattern
```bash
# Spawn at end of each wave's reasoning
{ agent: "researcher", task: "Research [specific angle]", run_in_background: true }
{ agent: "researcher", task: "Research [another angle]", run_in_background: true }
```

### Wave End Pattern
After all subagent results return:
1. Compile findings
2. Identify what's confirmed, what's uncertain, what's new
3. Decide: Is the goal clear enough to synthesize? Or do we need another wave?

## Output Format

### Per-Wave Output
```
## Wave N: [Wave Focus]

### Findings
- [Finding with citation]

### New Questions Raised
- [Question for next wave]

### Gaps Identified
- [What's missing]

### Recommended Next Wave
[Which angles to explore, and why]
```

### Final Synthesis (After Final Wave)
```
# Research Report: [Topic]

## Executive Summary
[2-3 sentence overview incorporating all waves]

## Key Findings
### Finding 1
[Description with citations]
### Finding 2
...

## Detailed Analysis
[Organized by theme or angle]

## Source Quality Assessment
| Source | Reliability | Key Contribution |
|--------|-------------|------------------|
| ...    | ...         | ...              |

## Open Questions / Gaps
[What wasn't found or needs verification]

## References
1. [Full citation with link]
2. ...
```

## Quality Checklist
- [ ] At least 3 distinct sources per major claim
- [ ] Both supporting and contradicting evidence noted
- [ ] Recency and authority of sources indicated
- [ ] Claims traceable to specific citations
- [ ] Open questions explicitly noted for potential follow-up

## Common Triggers for Next Wave

| Trigger | Action |
|---------|--------|
| "But what about X?" in findings | Add X to next wave |
| Conflicting data between sources | Verify with fact-checker subagent |
| "Minimum viable" questions | Research costs, timelines, requirements |
| "Who else is doing this?" | Research competition, existing players |
| "How do I actually do X?" | Add implementation-focused subagent |
| "Is this legal/regulated?" | Add regulatory compliance subagent |
| "What are the risks?" | Add risk assessment subagent |
| "How much money can I make?" | Add financial modeling subagent |
| Goal evolved based on findings | Adjust research scope, restart wave |

## Citation Protocol

Every claim MUST have a citation in format:
```
[Source: Author/Organization, Year, URL or Context]
```

## Example: Continuous Research Session

**User:** "What retail opportunities exist in India?"

**Wave 1 (4 agents):**
- Dropshipping viability
- Affiliate marketing potential
- Retail arbitrage mechanics
- Non-price-sensitive niches

**Wave 1 Findings:** Dropshipping has high failure rate due to COD; affiliate works but requires niche selection; arbitrage viable but hard to scale; several underserved niches identified.

**New Questions Raised:**
- What's the COD/RTO problem and how to mitigate?
- Which specific niches have lowest competition?
- What legal compliance is needed?
- How to combine multiple models?

**Wave 2 (5 agents):**
- COD/RTO solutions
- Premium niche deep-dives
- Legal compliance for e-commerce
- Hybrid model possibilities
- Subscription model analysis

**Wave 2 Findings:** Local suppliers solve COD; board games, Korean stationery, pet products identified as premium niches; GST mandatory for marketplace sellers; hybrid models can reduce risk.

**New Questions Raised:**
- What's the capital requirement for each niche?
- How to build community for niche products?
- What's the exit/acquisition potential?
- What skills can fund the product business?

**Wave 3 (4 agents):**
- Bootstrap/low-capital options
- Community building for niches
- Exit strategies and brand building
- Service-to-product transition paths

**Final Synthesis:** Three clear paths emerge based on capital and expertise level. Decision framework created.

---

*Use `research [topic]` for single-shot. Use `continuous research [topic]` or `keep going` to spawn multiple waves until synthesis is possible.*
