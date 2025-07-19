# Problem Solving Skill Module

## Cynefin Framework for Problem Classification

### Problem Domain: {{cynefin_domain}}

{{#if (eq cynefin_domain "simple")}}
**Simple Domain**
- Apply best practices
- Sense → Categorize → Respond
- Use standard procedures and processes
- Apply proven solutions from past successes
{{/if}}

{{#if (eq cynefin_domain "complicated")}}
**Complicated Domain**
- Apply good practices
- Sense → Analyze → Respond
- Requires expert knowledge and analysis
- Systems thinking and engineering approaches
{{/if}}

{{#if (eq cynefin_domain "complex")}}
**Complex Domain**
- Emergent practices
- Probe → Sense → Respond
- Learning through experiments and pilots
- Agile approaches and continuous adaptation
{{/if}}

{{#if (eq cynefin_domain "chaotic")}}
**Chaotic Domain**
- Novel practices
- Act → Sense → Respond
- Immediate action and crisis management
- Stabilize first, then move to other domains
{{/if}}

{{#if (eq cynefin_domain "disorder")}}
**Disorder Domain**
- Clarifying the situation is priority
- Gather information and analyze context
- Move to appropriate domain classification
{{/if}}

## Problem-Solving Approach

### Methodology: {{methodology}}
### Modern Framework: {{modern_framework}}

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

{{#if (eq modern_framework "a3")}}
**A3 Problem Solving Method**
- Background and current state understanding
- Goal setting and root cause analysis
- Countermeasure development and implementation plan
- Follow-up and standardization
- Visualization on A3-sized single sheet
{{/if}}

{{#if (eq modern_framework "8d")}}
**8D (8 Disciplines) Method**
1. D1: Team formation
2. D2: Problem description
3. D3: Containment actions
4. D4: Root cause identification
5. D5: Permanent corrective action selection
6. D6: Implementation and validation
7. D7: Prevention of recurrence
8. D8: Team and individual recognition
{{/if}}

{{#if (eq modern_framework "triz")}}
**TRIZ (Theory of Inventive Problem Solving)**
- Technical contradiction resolution
- Systematic application of inventive principles
- Evolution trend prediction
- Innovation process methodology
- Patent database insights
{{/if}}

{{#if (eq modern_framework "design_sprint")}}
**Design Sprint**
- 5-day intensive problem solving
- Understand → Define → Diverge → Decide → Prototype → Validate
- Customer-centered approach
- Rapid hypothesis validation
{{/if}}

## Data-Driven Problem Solving

### Data Availability: {{data_availability}}

{{#if (eq data_availability "rich")}}
**Rich Data Environment**
- Leverage big data analytics
- Machine learning pattern recognition
- Predictive analysis and anomaly detection
- Real-time monitoring dashboards
- A/B testing for solution validation
{{/if}}

{{#if (eq data_availability "moderate")}}
**Moderate Data Environment**
- Maximize existing data utilization
- Apply statistical analysis methods
- Develop data collection plans
- Establish KPIs and metrics
{{/if}}

{{#if (eq data_availability "limited")}}
**Limited Data Environment**
- Focus on qualitative data
- Leverage expert judgment
- Small-scale experiments for data collection
- Experience-based rules and heuristics
{{/if}}

### AI/ML Integration Approach

**Predictive Problem Identification**
- Anomaly detection algorithms
- Time series forecasting models
- Pattern recognition for early warning
- Preventive maintenance applications

**Real-time Problem Solving**
- Automated response systems
- Adaptive algorithms
- Feedback loop optimization
- Human-AI collaboration

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

### 2. Wicked Problems Response

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
- Multiple interpretations and solutions acceptable
- Gradual problem clarification
{{/if}}

{{#if (eq wicked_characteristics "low")}}
**Structured Problems**
- Clear problem definition possible
- Traditional problem-solving methods effective
- Optimal solution search feasible
{{/if}}

### 3. Root Cause Analysis

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

### 4. Solution Generation

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

### 5. Decision Making

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

### 6. Implementation Planning

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

### 7. PDCA Cycle

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

### 8. Continuous Improvement and Learning

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

### A3 Problem Solving Template
```
## Background & Current State
[Problem background and current situation]

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

### 8D Problem Solving Template
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
   - Recognize cognitive biases

2. **Structured Thinking**
   - MECE (Mutually Exclusive, Collectively Exhaustive)
   - Use logic trees
   - Hypothesis-driven approach
   - Practice systems thinking

3. **Continuous Improvement**
   - Learn from failures
   - Build knowledge base
   - Optimize processes
   - Promote organizational learning

4. **Communication**
   - Engage stakeholders
   - Ensure transparency
   - Utilize feedback
   - Knowledge sharing and transfer

5. **Adaptive Approach**
   - Select methods based on problem nature
   - Emphasize experimentation and learning
   - Handle complexity appropriately
   - Accept unpredictability

6. **Technology Utilization**
   - Effective use of AI/ML tools
   - Advanced data analysis
   - Promote automation
   - Integrate digital tools

7. **Sustainability**
   - Maintain long-term perspective
   - Efficient resource utilization
   - Consider social impact
   - Care for future generations