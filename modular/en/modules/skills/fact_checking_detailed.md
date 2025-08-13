# Fact-Checking Skills - Detailed Version

## Executive Summary

A comprehensive skill set for systematically verifying the accuracy of AI-provided information and preventing misinformation/disinformation. Integrates International Fact-Checking Network (IFCN) principles, academic verification methods, and journalism best practices to ensure information quality in the AI era.

## Theoretical Background

### Information Disorder Spectrum
- **Misinformation**: False information spread unintentionally
- **Disinformation**: False information created and spread deliberately
- **Malinformation**: True information used to cause harm

### AI Hallucination Classification
1. **Factual Hallucination**: Creation of non-existent facts
2. **Logical Hallucination**: Construction of false causal relationships
3. **Contextual Hallucination**: Information used in inappropriate context
4. **Temporal Hallucination**: Information containing temporal contradictions

## Comprehensive Verification Framework

### 1. SIFT Method (Mike Caulfield)
```yaml
Stop:
  - Pause emotional reactions
  - Check existing knowledge
  - Assess need for verification

Investigate:
  - Research source credibility
  - Confirm author expertise
  - Check publisher reputation

Find:
  - Search for better sources
  - Confirm expert opinions
  - Prioritize academic sources

Trace:
  - Trace back to original source
  - Confirm citation chain
  - Track information evolution
```

### 2. Five Pillars Verification Method
```yaml
Source:
  Evaluation Items:
    - Domain authority
    - Editorial transparency
    - Correction history disclosure
    - Funding source disclosure

Evidence:
  Evaluation Items:
    - Data source attribution
    - Methodology transparency
    - Reproducibility
    - Peer review presence

Context:
  Evaluation Items:
    - Complete quotation
    - Historical background consideration
    - Regional characteristics understanding
    - Linguistic nuances

Corroboration:
  Evaluation Items:
    - Number of independent sources
    - Information concordance
    - Expert consensus
    - Existence of opposing views

Credibility:
  Evaluation Items:
    - Past accuracy record
    - Relevance to expertise
    - Bias disclosure
    - Response to corrections
```

### 3. Evidence Pyramid (Applied Medical Evidence Hierarchy)
```
Level 1: Systematic Reviews & Meta-analyses
├── Integrated analysis of multiple RCTs
├── Systematic reviews (e.g., Cochrane Reviews)
└── Statistical meta-analyses

Level 2: Randomized Controlled Trials (RCT)
├── Double-blind trials
├── Placebo-controlled trials
└── Cluster randomized trials

Level 3: Observational Studies
├── Cohort studies
├── Case-control studies
└── Cross-sectional studies

Level 4: Expert Opinions & Case Reports
├── Peer-reviewed expert opinions
├── Guidelines & recommendations
└── Case reports & case studies

Level 5: Other Information Sources
├── Official government announcements
├── Industry reports
└── News reports
```

## Advanced Verification Techniques

### Digital Forensics
```yaml
Image Verification:
  - EXIF data analysis
  - Pixel-level alteration detection
  - Reverse image search (TinEye, Google Lens)
  - Photo forensic tools usage

Video Verification:
  - Frame-by-frame analysis
  - Audio synchronization confirmation
  - Deepfake detection
  - Metadata consistency

Document Verification:
  - Stylometry analysis
  - Language pattern analysis
  - Timestamp verification
  - Version history tracking
```

### Statistical Verification
```yaml
Data Quality Assessment:
  - Sample size adequacy
  - Statistical significance confirmation
  - Effect size evaluation
  - Confidence interval interpretation

Bias Detection:
  - Selection bias
  - Publication bias
  - Confirmation bias
  - Survivorship bias

Method Validity:
  - Research design appropriateness
  - Confounding factor control
  - Multiple comparison correction
  - External validity assessment
```

### Network Analysis
```yaml
Information Spread Patterns:
  - Origin identification
  - Spread path tracking
  - Influencer identification
  - Bot detection

Citation Networks:
  - Mutual citation detection
  - Citation quality evaluation
  - Influence measurement
  - Echo chamber identification
```

## Domain-Specific Verification Protocols

### Science & Medical Information
```yaml
Required Confirmation Items:
  - Peer review presence and journal quality
  - Conflict of interest disclosure
  - Study registration number (clinical trials)
  - Ethics committee approval
  - Data availability statement

Evaluation Criteria:
  - CONSORT statement compliance (RCT)
  - STROBE statement compliance (observational studies)
  - PRISMA statement compliance (systematic reviews)
  - ARRIVE guidelines compliance (animal studies)
```

### Political & Policy Information
```yaml
Verification Points:
  - Cross-reference with official records
  - Statement completeness confirmation
  - Context appropriateness
  - Numerical source confirmation
  - Timeline consistency

Source Hierarchy:
  1. Minutes & official records
  2. Government statistics & white papers
  3. Public speeches & statements
  4. Interview records
  5. Secondary reporting
```

### Economic & Business Information
```yaml
Data Verification:
  - Financial statement confirmation
  - Regulatory filing verification
  - Audit report confirmation
  - Industry standard comparison
  - Time series consistency

Reliability Indicators:
  - Listed company disclosures
  - Rating agency evaluations
  - Analyst reports
  - Trade association statistics
  - Independent research data
```

### Social Media Information
```yaml
Account Verification:
  - Verification badge confirmation
  - Account history
  - Posting pattern analysis
  - Follower quality

Content Verification:
  - Original post identification
  - Edit/alteration traces
  - Location data consistency
  - Timestamp confirmation
```

## Cultural & Regional Considerations

### Japan-Specific Verification Points
```yaml
Source Characteristics:
  - Press club system influence
  - Ministry announcement interpretation
  - Industry association positioning
  - Expert affiliation confirmation

Linguistic Challenges:
  - Translation accuracy
  - Cultural context understanding
  - Technical term interpretation
  - Nuance comprehension

Social Context:
  - Organizational power dynamics
  - Implicit understandings
  - Seasonality & timeliness
  - Regional difference consideration
```

### International Perspective
```yaml
Global Standards:
  - WHO/UN international organization standards
  - ISO international standards
  - Academic consensus
  - Multilateral agreements & treaties

Regional Differences:
  - Legal system differences
  - Measurement standard variations
  - Cultural interpretation differences
  - Time zone & calendar considerations
```

## Implementation Guidelines

### Checklist Implementation
```yaml
Phase 1 - Initial Assessment (1-2 min):
  □ Source confirmation
  □ Date confirmation
  □ Author confirmation
  □ Obvious error presence

Phase 2 - Basic Verification (3-5 min):
  □ Multiple source confirmation
  □ Fact vs. opinion distinction
  □ Number/statistics confirmation
  □ Citation accuracy

Phase 3 - Detailed Verification (10-15 min):
  □ Original source confirmation
  □ Expert opinion confirmation
  □ Opposing view consideration
  □ Bias evaluation

Phase 4 - Comprehensive Assessment (5 min):
  □ Confidence scoring
  □ Limitation specification
  □ Additional verification necessity
  □ Recommended actions
```

### Automatable Processes
```python
# Conceptual Implementation Example
class FactChecker:
    def __init__(self):
        self.verification_tools = {
            'url_validator': self.validate_url,
            'date_checker': self.check_dates,
            'source_ranker': self.rank_sources,
            'bias_detector': self.detect_bias
        }
    
    def verify_claim(self, claim, depth='standard'):
        results = {
            'claim': claim,
            'verification_level': depth,
            'checks_performed': [],
            'confidence_score': 0,
            'issues_found': []
        }
        
        # Execute staged verification
        for tool_name, tool_func in self.verification_tools.items():
            result = tool_func(claim)
            results['checks_performed'].append(tool_name)
            results['confidence_score'] += result['score']
            if result['issues']:
                results['issues_found'].extend(result['issues'])
        
        return results
```

## Performance Metrics

### KPI Settings
```yaml
Efficiency Metrics:
  - Basic verification completion: <5 min
  - Detailed verification completion: <30 min
  - Automation rate: >60%
  - Daily processing capacity: >50 items

Quality Metrics:
  - Verification accuracy: >95%
  - False Positive rate: <5%
  - False Negative rate: <3%
  - Verification depth achievement: >90%

Impact Metrics:
  - Misinformation prevention rate: >85%
  - User trust level: >4.5/5
  - Decision-making improvement: Measurable improvement
  - Cost reduction effect: >20%
```

### Continuous Improvement
```yaml
Monthly Review:
  - Verification log analysis
  - Misclassification cause analysis
  - Process improvement proposals
  - Tool update consideration

Quarterly Evaluation:
  - KPI achievement evaluation
  - Benchmark comparison
  - New technology adoption consideration
  - Training necessity

Annual Review:
  - Framework updates
  - International standard alignment
  - New threat response
  - Long-term strategy adjustment
```

## Risk Management

### Verification Limitations
```yaml
Recognized Constraints:
  - Impossibility of complete verification
  - Compromises due to time constraints
  - Information access limitations
  - Expertise limitations

Countermeasures:
  - Clear disclosure of limitations
  - Graduated confidence assessment
  - Additional expert consultation recommendation
  - Continuous monitoring
```

### Legal & Ethical Considerations
```yaml
Compliance:
  - Copyright law adherence
  - Privacy protection
  - Defamation avoidance
  - Freedom of Information Act utilization

Ethical Principles:
  - Transparency assurance
  - Fairness maintenance
  - Harm minimization
  - Public interest priority
```

## Future Outlook

### New Technology Integration
- **AI-Assisted Verification**: Automated verification using machine learning
- **Blockchain**: Information tampering prevention
- **Quantum Cryptography**: Information authenticity guarantee
- **Augmented Reality**: Real-time verification display

### Development Directions
- Enhanced multilingual support
- Real-time verification realization
- Predictive fact-checking
- Collaborative verification networks

Through continuous development and appropriate implementation of this skill, we can maintain the health of the information ecosystem in the AI era and strengthen the foundation of social trust.