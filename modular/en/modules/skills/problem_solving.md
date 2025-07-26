# Problem Solving Skill Module
## Cynefin Framework for Problem Classification
## Problem-Solving Approach
## Data-Driven Problem Solving
## Problem-Solving Process
Problem Definition and Clarification
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
- Define the problem in measurable terms
- Specify impact scope and importance
Wicked Problems Response
{{#if (eq wicked_characteristics "high")}}
**High Wicked Problem Characteristics**
- Problem definition itself is difficult
- No unique correct solution exists
- Learning through trial and error
- Conflicting stakeholder values
- Long-term perspective required
**Adaptive Management Strategies**
- Incremental approach
- Diverse stakeholder engagement
- Continuous learning and adjustment
- Parallel implementation of multiple solutions
- System-wide evolution promotion
{{/if}}
{{#if (eq wicked_characteristics "moderate")}}
**Moderate Wicked Problem Characteristics**
- Mix of structured and unstructured elements
- Gradual problem clarification
{{/if}}
{{#if (eq wicked_characteristics "low")}}
**Structured Problems**
- Clear problem definition possible
- Traditional problem-solving methods effective
- Optimal solution search feasible
{{/if}}
Root Cause Analysis
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
Solution Generation
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
Decision Making
**Evaluation Criteria: {{decision_criteria}}**
{{#if (gte problem_complexity "moderate")}}
**Decision Matrix**
**Weighted Scoring**
- Set importance weights for each criterion
- Calculate scores for objective comparison
{{/if}}
**Risk Analysis**
- Identify risks for each solution
- Evaluate impact and probability
- Consider risk mitigation strategies
Implementation Planning
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
PDCA Cycle
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
Continuous Improvement and Learning
**Promoting Organizational Learning**
- Systematic collection of failure cases
- Best practice sharing
- Knowledge base construction
- Cross-team knowledge transfer
**Process Evolution**
- Regular review of problem-solving methods
- Introduction of new tools and technologies
- Feedback-based improvements
- Organizational capability enhancement
## Documentation
{{#if (eq documentation_style "comprehensive")}}
## Advanced Problem-Solving Techniques
### TRIZ Evolution Trends
**Technical System Evolution Laws**
1. Law of completeness
2. Law of energy conductivity
3. Law of harmonization
4. Law of ideality
5. Law of uneven development
6. Law of transition to super-system
7. Law of transition to micro-level
8. Law of increasing automation
**Inventive Principles Application**
- Segmentation
- Taking out
- Local quality
- Asymmetry
- Merging
- Multi-functionality
- Equipotentiality
- Preliminary action
### Advanced Systems Thinking
**Leverage Points (Donella Meadows)**
1. Paradigms
2. Goals
3. Power structures
4. Rules
5. Information flows
6. Information access
7. Feedback loops
8. Parameters
9. Physical structure
**System Archetypes**
- Limits to growth
- Shifting the burden
- Tragedy of commons
- Success to successful
- Tragedy of competition
## Templates and Frameworks
```
## Problem Clarification
[Specific problem and measurable indicators]
## Target
[Desired state and success criteria]
## Root Cause Analysis
[5 Whys analysis or fishbone diagram results]
## Countermeasures
[Actions to implement and responsible parties]
## Implementation Plan
[Timeline, milestones, resources]
## Follow-up
[Effect measurement and standardization plan]
```
## D1: Team Formation
[Problem solving team members and roles]
## D2: Problem Description
[Problem clarification using 5W1H]
## D3: Containment Actions
[Emergency response and temporary measures]
## D4: Root Cause
[5 Whys analysis and verification results]
## D5: Permanent Corrective Actions
[Actions addressing root causes]
## D6: Implementation and Validation
[Action implementation and effect confirmation]
## D7: Prevention of Recurrence
[System and process improvements]
## D8: Completion and Recognition
[Result confirmation and learning sharing]
```
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
## Symptoms
[Observable problems]
## 5 Whys Analysis
1. Why? → [Cause 1]
2. Why? → [Cause 2]
3. Why? → [Cause 3]
4. Why? → [Cause 4]
5. Why? → [Root cause]
## Verification
```
## Options
1. [Solution 1]
2. [Solution 2]
3. [Solution 3]
## Evaluation
| Criteria | Option 1 | Option 2 | Option 3 |
|----------|----------|----------|----------|
## Recommendation
[Selected solution and rationale]
```
## Best Practices
1. **Bias Elimination**
2. **Structured Thinking**
3. **Continuous Improvement**
4. **Communication**
5. **Adaptive Approach**
6. **Technology Utilization**
7. **Sustainability**