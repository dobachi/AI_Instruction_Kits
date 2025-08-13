# Fact-Checking Skills

## Overview

A systematic skill for verifying the accuracy of AI-provided information and research results, preventing misinformation and disinformation. Ensures information reliability through multi-source verification, source evaluation, cross-referencing, and evidence hierarchy assessment.

### Problems Solved
- **Hallucination**: AI-generated information that differs from facts
- **Information Pollution**: Prevention of misinformation/disinformation spread
- **Confirmation Bias**: Tendency to select only convenient information
- **Source Reliability**: Dependence on uncertain information sources

## Core Functions

### 1. Multi-Source Verification System
Fact-checking through multiple independent information sources

**Verification Levels**:
- **Level 1**: Confirmation via single reliable source
- **Level 2**: Confirmation via 2+ independent sources
- **Level 3**: Confirmation via official institutions/experts
- **Level 4**: Confirmation via peer-reviewed research/government statistics

### 2. Source Evaluation Matrix
Systematic evaluation of source credibility

**Evaluation Criteria**:
- **Authority**: Source expertise and track record
- **Independence**: Presence/absence of conflicts of interest
- **Transparency**: Degree of methodology/data disclosure
- **Currency**: Information update frequency and freshness
- **Verifiability**: Accessibility to original sources

### 3. Cross-Reference Analysis
Systematic comparison of agreements/discrepancies between multiple sources

**Analysis Methods**:
1. Fact concordance checking
2. Numerical/date consistency verification
3. Context appropriateness evaluation
4. Citation accuracy verification

### 4. Evidence Hierarchy Evaluation
Hierarchical evaluation of evidence quality

**Evidence Hierarchy (higher = more reliable)**:
1. **Meta-analysis/Systematic reviews**
2. **Randomized Controlled Trials (RCT)**
3. **Cohort studies/Case-control studies**
4. **Peer-reviewed expert opinions**
5. **Official government statistics/reports**
6. **Industry reports/White papers**
7. **News reports (multiple confirmations)**
8. **Single reports/Blogs/Social media**

### 5. Fact-Checking Protocol
Standardized verification procedures

**Verification Steps**:
1. **Claim Decomposition**: Break down into verifiable elements
2. **Source Identification**: Confirm primary sources
3. **Independent Verification**: Multi-path fact confirmation
4. **Context Verification**: Evaluate citation appropriateness
5. **Timeline Confirmation**: Temporal consistency check
6. **Conclusion**: Confidence score and evidence presentation

## Variable Utilization

### verification_depth
- **basic**: Basic fact-checking
- **standard**: Standard multi-verification
- **thorough**: Comprehensive verification
- **forensic**: Forensic-level detailed verification

### source_requirements
- **minimum**: Minimal source confirmation
- **multiple**: Multiple sources required
- **authoritative**: Authoritative sources required
- **primary_only**: Primary sources only

### confidence_threshold
- **low**: Approve with 60%+ confidence
- **medium**: Approve with 75%+ confidence
- **high**: Approve with 90%+ confidence
- **absolute**: Require 100% certainty

### reporting_style
- **binary**: True/false binary judgment
- **graded**: Graduated confidence assessment
- **detailed**: Include detailed verification process
- **summary**: Provide summary only

### cultural_context
- **japanese**: Emphasize Japanese sources/context
- **international**: International perspective verification
- **regional**: Consider region-specific context
- **universal**: Universal standard evaluation

## Implementation Patterns

### CRAAP Test
Standard framework for information evaluation
```yaml
Evaluation Items:
  Currency: "When was information published/updated?"
  Relevance: "Is information suitable for purpose?"
  Authority: "Is author/publisher credible?"
  Accuracy: "Is information accurate and verifiable?"
  Purpose: "Is publication purpose clear?"
```

### Triangulation Method
```yaml
Method:
  Source A: "Government statistical data"
  Source B: "Academic research papers"
  Source C: "Industry expert opinions"
  
Conclusion: "Same fact confirmed from three independent perspectives"
```

### Red Flag Detection
```yaml
Warning Signs:
  - "Emotional/inflammatory language use"
  - "No source attribution"
  - "Extreme claims/absolute statements"
  - "Logical leaps/causal misattribution"
  - "Cherry-picking (selective data choice)"
  - "Over-reliance on anonymous sources"
```

### Confidence Scoring
```yaml
Score Calculation:
  Source Quality: 30 points
  Multiple Confirmation: 25 points
  Currency: 15 points
  Context Appropriateness: 15 points
  Verifiability: 15 points
  
Overall Rating:
  90-100 points: "High reliability"
  70-89 points: "Medium reliability"
  50-69 points: "Requires additional verification"
  0-49 points: "Low reliability/Unconfirmed"
```

## Best Practices

### Verification Priorities
| Highest Priority | Standard | Low Priority |
|-----------------|----------|--------------|
| Statistics/numerical data | General knowledge | Opinions/speculation |
| Causal claims | Established facts | Future predictions |
| Novel/unusual claims | Widely known information | Subjective evaluations |

### Bias Countermeasures
- **Confirmation Bias**: Actively search opposing views
- **Availability Heuristic**: Prioritize statistical data
- **Anchoring Bias**: Reference multiple initial sources
- **Authority Bias**: Independently evaluate content

### Ensuring Transparency
```yaml
Reporting Elements:
  - List of sources used
  - Items that couldn't be verified
  - Clear statement of uncertainty
  - Potential conflicts of interest
  - Verification date and expiration
```

## Common Mistakes

### Patterns to Avoid
- **Single Source Dependency**: Judging from one source only
- **Circular Reference**: False confirmation via mutual citation
- **Timeline Ignorance**: Treating old information as current
- **Context Ignorance**: Meaning distortion through partial quotes
- **Excessive Skepticism**: Total denial without rational basis

### Improvement Measures
- Confirm at least 3 independent sources
- Trace back to original sources
- Always check information dates
- Evaluate including surrounding context
- Adopt graduated confidence assessment

## Use Cases

### AI-Generated Content Verification
```yaml
Settings: verification_depth="thorough", source_requirements="multiple"

Verification Process:
  1. Decompose AI claim: "Japan's GDP ranks 3rd globally"
  2. Confirm official sources: IMF, World Bank data
  3. Time verification: 2024 latest data
  4. Cross-check: Multiple economic institution data
  Result: "Confirmed (95% confidence)"
```

### Scientific Claim Verification
```yaml
Settings: verification_depth="forensic", source_requirements="primary_only"

Verification Process:
  1. Claim: "Drug X shows 90% efficacy"
  2. Confirm original paper: Peer-reviewed journal
  3. Evaluate methodology: RCT, sample size
  4. Confirm reproducibility: Replication studies
  5. Conflict of interest check: Funding sources
  Result: "Conditionally confirmed (effective under specific conditions)"
```

### News Article Verification
```yaml
Settings: verification_depth="standard", reporting_style="detailed"

Verification Process:
  1. Confirm headline-body consistency
  2. Verify source authenticity
  3. Check other media reports
  4. Cross-reference with official announcements
  5. Confirm timeline consistency
  Result: "Partially confirmed (errors in details)"
```

## Technical Tool Utilization

### Recommended Tools
- **Google Scholar**: Academic literature search/verification
- **PubMed**: Medical/life science paper confirmation
- **Wayback Machine**: Past webpage confirmation
- **TinEye/Google Image Search**: Image source confirmation
- **Snopes/FactCheck.org**: Existing fact-check confirmation

### Verification Support Tools
```yaml
Automatable Verifications:
  - URL validity checking
  - Citation format confirmation
  - Statistical outlier detection
  - Text similarity analysis
  - Timestamp confirmation
```

## Quality Indicators

- **Verification Completeness**: 90%+ of claims verified
- **Source Diversity**: 3+ independent sources used
- **Response Time**: Basic verification within 5 min, detailed within 30 min
- **False Detection Rate**: False Positive <5%
- **Transparency**: 100% disclosure of verification process

## Legal and Ethical Considerations

### Precautions
- **Defamation Avoidance**: Avoid personal attacks with unconfirmed information
- **Copyright Consideration**: Proper use of citations
- **Privacy Protection**: Careful verification of personal information
- **Cultural Sensitivity**: Recognize regional/cultural relativity of truth

By properly utilizing this skill, we can ensure information quality in the AI era and significantly improve decision-making reliability.