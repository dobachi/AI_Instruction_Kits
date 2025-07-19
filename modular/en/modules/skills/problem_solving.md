# Problem Solving Skill Module

## Problem-Solving Approach

### Methodology: {{methodology}}

{{#if (eq methodology "analytical")}}
**Analytical Approach**
- Data-driven decision making
- Quantitative evaluation
- Logical reasoning
- Evidence-based conclusions
{{/if}}

{{#if (eq methodology "creative")}}
**Creative Approach**
- Out-of-the-box thinking
- Brainstorming
- Divergent thinking
- Innovative solutions
{{/if}}

{{#if (eq methodology "systematic")}}
**Systematic Approach**
- Structured methods
- Step-by-step process
- Comprehensive analysis
- Reproducible methodology
{{/if}}

## Problem-Solving Process

### 1. Problem Definition and Clarification

{{#if (eq problem_complexity "complex")}}
#### Handling Complex Problems
- Problem decomposition and structuring
- Understanding interrelationships
- Setting priorities
{{/if}}

**5W1H Framework**
- What: Specific content of the problem
- Why: Reasons why the problem is important
- When: Occurrence timing and deadlines
- Where: Problem location and scope
- Who: Stakeholders and involved parties
- How: Problem occurrence mechanism

**Problem Statement**
- Clearly describe the gap between current and ideal state
- Define the problem in measurable terms
- Specify impact scope and importance

### 2. Root Cause Analysis

{{#if (gte analysis_depth "standard")}}
**5 Whys Analysis**
1. Start with the surface problem
2. Repeatedly ask "Why?" to dig deeper
3. Continue until reaching the root cause
4. Verify evidence at each stage
{{/if}}

{{#if (eq analysis_depth "deep")}}
**Fishbone Diagram (Ishikawa)**
```
Main Categories:
├─ People
├─ Process
├─ Technology
├─ Environment
└─ Materials
```

**Systems Thinking**
- Analyze interactions between elements
- Identify feedback loops
- Discover leverage points
{{/if}}

### 3. Solution Generation

{{#if (eq collaboration_level "team")}}
**Team Idea Generation**
- Conduct brainstorming sessions
- Integrate diverse perspectives
- Suspend critical thinking temporarily
{{/if}}

**Solution Generation Techniques**
- Analogy: Adapt from similar problems
- Reversal: Think about the problem backwards
- Division: Break down the problem
- Integration: Combine multiple solutions

### 4. Decision Making

**Evaluation Criteria: {{decision_criteria}}**

{{#if (gte problem_complexity "moderate")}}
**Decision Matrix**
| Solution | Effectiveness | Feasibility | Risk | Cost | Overall Score |
|----------|---------------|-------------|------|------|---------------|
| Option 1 | High/Med/Low  | High/Med/Low| High/Med/Low | High/Med/Low | Score |
| Option 2 | High/Med/Low  | High/Med/Low| High/Med/Low | High/Med/Low | Score |

**Weighted Scoring**
- Set importance weights for each criterion
- Calculate scores for objective comparison
{{/if}}

**Risk Analysis**
- Identify risks for each solution
- Evaluate impact and probability
- Consider risk mitigation strategies

### 5. Implementation Planning

{{#if time_constraint}}
**Time Constraint: {{time_constraint}}**
{{/if}}

**Action Plan Development**
- Define specific tasks
- Clarify responsibilities
- Set milestones
- Allocate resources

{{#if (eq collaboration_level "cross-functional")}}
**Cross-functional Coordination**
- Stakeholder mapping
- Communication planning
- Dependency management
{{/if}}

### 6. PDCA Cycle

**Plan**
- Set objectives
- Define success metrics
- Detail implementation procedures

**Do**
- Execute according to plan
- Record progress
- Early problem detection

**Check**
- Measure results
- Compare with objectives
- Analyze deviations

**Act**
- Standardize success factors
- Correct problems
- Apply to next cycle

## Documentation

{{#if (eq documentation_style "comprehensive")}}
### Comprehensive Documentation
- Problem definition document
- Analysis report
- Decision records
- Implementation plan
- Progress reports
- Retrospective documents
{{/if}}

{{#if (eq documentation_style "standard")}}
### Standard Documentation
- Problem and solution summary
- Key decision records
- Action item list
{{/if}}

{{#if (eq documentation_style "minimal")}}
### Minimal Documentation
- Conclusions and next steps
- Critical decisions only
{{/if}}

## Templates and Frameworks

### Problem Definition Template
```
## Problem Overview
[Brief problem description]

## Current State
- [Current situation]
- [Measurable metrics]

## Ideal State
- [Target state]
- [Success criteria]

## Gap Analysis
- [Difference between current and ideal]
- [Impact and importance]
```

### Root Cause Analysis Template
```
## Symptoms
[Observable problems]

## 5 Whys Analysis
1. Why? → [Cause 1]
2. Why? → [Cause 2]
3. Why? → [Cause 3]
4. Why? → [Cause 4]
5. Why? → [Root cause]

## Verification
[Evidence and verification methods for each cause]
```

### Decision Template
```
## Options
1. [Solution 1]
2. [Solution 2]
3. [Solution 3]

## Evaluation
| Criteria | Option 1 | Option 2 | Option 3 |
|----------|----------|----------|----------|
| [Criterion 1] | [Rating] | [Rating] | [Rating] |
| [Criterion 2] | [Rating] | [Rating] | [Rating] |

## Recommendation
[Selected solution and rationale]
```

## Best Practices

1. **Bias Elimination**
   - Avoid confirmation bias
   - Incorporate diverse perspectives
   - Make data-based decisions

2. **Structured Thinking**
   - MECE (Mutually Exclusive, Collectively Exhaustive)
   - Use logic trees
   - Hypothesis-driven approach

3. **Continuous Improvement**
   - Learn from failures
   - Build knowledge base
   - Optimize processes

4. **Communication**
   - Engage stakeholders
   - Ensure transparency
   - Utilize feedback