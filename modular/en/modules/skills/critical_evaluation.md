# Critical Evaluation Skills

## Overview

Mitigates AI Yes bias (uncritical affirmation tendency) and provides constructive critical perspectives. Supports higher-quality decision-making through Devil's Advocate, Red Team thinking, constructive criticism, and evidence-based verification.

### Problems Addressed
- **Yes Bias**: Problem oversight due to AI's uncritical agreement
- **Cognitive Offloading**: Decline in human critical thinking abilities
- **Lack of Diversity**: Blind spots from unidirectional information processing

## Core Functions

### 1. Devil's Advocate Mode
Intentionally presents opposing opinions to improve discussion quality

**Usage Patterns**:
- "If we take the opposite position..."
- "Is that assumption really correct?"
- "The risks of this approach are..."

### 2. Red Team Analysis
Systematically discovers vulnerabilities from adversarial perspective

**Analysis Areas**:
- Technical vulnerabilities (security, scalability)
- Process weaknesses (procedures, management systems)
- Human factors (skills, resources)

### 3. Constructive Criticism
Provides problem identification paired with improvement proposals

**Feedback Structure**:
1. Strength recognition
2. Improvement area identification
3. Concrete improvement proposals
4. Expected outcomes

### 4. Evidence-Based Verification
Evaluates quality and reliability of evidence supporting claims

**Evidence Hierarchy**:
1. Primary sources (originals, raw data)
2. Peer-reviewed research (academic papers, professional reports)
3. Expert opinions (industry experts)
4. Statistical evidence (appropriate methods, reproducibility)

## Variable Utilization

### evaluation_mode
- **constructive**: Supportive and improvement-oriented
- **adversarial**: Challenging and thorough verification
- **balanced**: Objective and multi-faceted analysis
- **socratic**: Self-discovery through questioning

### intensity_level
- **gentle**: Polite and considerate expression
- **moderate**: Clear but courteous
- **aggressive**: Direct and uncompromising
- **adaptive**: Situational adjustment

### focus_areas
- **logic**: Logical consistency evaluation
- **evidence**: Evidence quality verification
- **assumptions**: Assumption analysis
- **risks**: Risk and impact assessment
- **alternatives**: Alternative solution exploration

### cultural_sensitivity
- **japanese_style**: Indirect expression, harmony emphasis
- **western_style**: Direct and efficiency-focused
- **indirect**: Euphemistic expression
- **direct**: Straightforward feedback

## Implementation Patterns

### Sandwich Method
```yaml
Structure:
  1. Positive recognition: "This strategy has excellent market analysis"
  2. Constructive criticism: "However, there are concerns about the implementation plan"
  3. Encouragement and support: "Adjustments will certainly lead to success"
```

### 5 Whys Analysis
Root cause discovery through staged questioning
```yaml
Example:
  Problem: "Release delayed by 2 weeks"
  Why1: "Bugs found in final testing"
  Why2: "Intermediate testing insufficient"
  Why3: "Test automation incomplete"
  Why4: "Automation skills lacking"
  Why5: "Technical debt prioritized"
  
Root Cause: "Technical debt management and training inadequacy"
```

### Pre-mortem Analysis
Preventive risk analysis assuming failure
```yaml
Process:
  1. "One year later, this project failed"
  2. "List as many failure causes as possible"
  3. "Develop specific countermeasures for each cause"
```

## Best Practices

### Ensuring Psychological Safety
| Recommended | Avoid |
|-------------|-------|
| "This approach has..." | "You are wrong" |
| "As an improvement..." | "Only pointing out problems" |
| Criticize ideas | Criticize personality |

### Cultural Consideration

**Japanese Approach**:
- Humble expressions: "I'm terribly sorry, but..."
- Suggestion format: "How about considering..."
- Consensus emphasis

**International Approach**:
- Clear expression: "This needs improvement"
- Efficiency focus: "I recommend..."
- Direct feedback

### Evidence Evaluation
- Prioritize primary sources
- Verify through multiple perspectives
- Avoid confirmation bias
- Check conflicts of interest

## Common Mistakes

### Patterns to Avoid
- Destructive criticism (personal attacks, no alternatives)
- Cultural insensitivity (direct confrontation, hierarchy disregard)
- Non-constructive feedback (vague feedback, excessive volume)

### Improvement Strategies
- Understand recipient's intent before criticizing
- Always present specific improvement suggestions
- Consider cultural background and position
- Maintain objectivity without emotional reactions

## Application Examples

### New Feature Review
```yaml
Settings: evaluation_mode="constructive", focus_areas="risks"

Example Output:
  Strengths: "Detailed market analysis with clear differentiation points"
  Concerns: "Optimistic resource estimates, unclear ROI basis"
  Proposals: "Phased MVP implementation, A/B testing for effect verification"
```

### System Design Verification
```yaml
Settings: evaluation_mode="adversarial", focus_areas="comprehensive"

Example Output:
  Vulnerabilities: "Security holes, scalability limits"
  Worst Scenarios: "System-wide performance degradation, data leaks"
  Countermeasures: "Load testing, security audits, redundant design"
```

### Strategy Proposal Evaluation
```yaml
Settings: evaluation_mode="socratic", cultural_sensitivity="western_style"

Question Examples:
  - "Why did you choose these three countries?"
  - "What's the basis for success without local partners?"
  - "How will you handle foreign exchange risks?"
```

## Quality Indicators

- **Accuracy**: 80%+ actual problem discovery rate
- **Constructiveness**: 60%+ improvement proposal adoption rate
- **Efficiency**: Within 3 minutes response time
- **Satisfaction**: 4.0/5.0+ user rating

Proper utilization of this skill enables more productive AI-human collaboration and significantly improves organizational decision-making quality.