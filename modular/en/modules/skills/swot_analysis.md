# SWOT Analysis Skill Module

## Basic Structure of SWOT Analysis

{{#if analysis_scope}}
**Analysis Target**: {{analysis_scope}}
{{/if}}

{{#if detail_level}}
**Detail Level**: {{detail_level}}
{{/if}}

### Four Elements of SWOT Analysis

#### S: Strengths - Internal/Positive
- Sources of competitive advantage
- Unique resources and capabilities
- Track record and know-how
- Brand value and reputation

#### W: Weaknesses - Internal/Negative
- Areas requiring improvement
- Lack of resources or capabilities
- Points inferior to competitors
- Internal constraints and issues

#### O: Opportunities - External/Positive
- Market growth trends
- Technological innovation and social changes
- Deregulation and policy support
- Emergence of new needs

#### T: Threats - External/Negative
- Intensifying competition and new entrants
- Market shrinkage and demand decline
- Regulatory tightening and legal risks
- Technological obsolescence

## Analysis Process

{{#switch detail_level}}
{{#case "quick"}}
### Quick Analysis (30 minutes - 1 hour)
1. **Brainstorming** (5-7 items per element)
2. **Filtering by importance** (narrow to 3-5 items per element)
3. **Concise strategic recommendations** (1-2 pages)
{{/case}}
{{#case "standard"}}
### Standard Analysis (Half day - 1 day)
1. **Information gathering and environmental analysis**
2. **Detailed identification of SWOT elements** (10-15 items per element)
3. **Evaluation and prioritization**
4. **TOWS matrix creation**
5. **Development of strategic options** (3-5 pages)
{{/case}}
{{#case "comprehensive"}}
### Comprehensive Analysis (Several days - 1 week)
1. **Extensive research and data collection**
2. **Stakeholder interviews**
3. **Detailed SWOT analysis** (15+ items per element)
4. **Quantitative evaluation and weighting**
5. **Complete TOWS matrix and strategic roadmap**
6. **Implementation plan and KPI setting** (10+ pages)
{{/case}}
{{/switch}}

## Evaluation Criteria and Scoring

{{#if evaluation_criteria}}
### Evaluation Approach: {{evaluation_criteria}}
{{/if}}

### Evaluation Perspectives

#### Evaluation of Strengths/Weaknesses
1. **Importance** (Impact on business)
   - High (5 points): Core competitive factor
   - Medium (3 points): Important but not decisive
   - Low (1 point): Limited impact

2. **Sustainability**
   - High (5 points): Maintainable long-term
   - Medium (3 points): Effective medium-term
   - Low (1 point): Short-term/temporary

3. **Uniqueness** (for strengths)
   - High (5 points): Difficult to imitate
   - Medium (3 points): Takes time to imitate
   - Low (1 point): Easily imitable

#### Evaluation of Opportunities/Threats
1. **Probability of Occurrence**
   - High (5 points): Almost certain (80%+)
   - Medium (3 points): Likely (50-80%)
   - Low (1 point): Unlikely (less than 50%)

2. **Impact Level**
   - High (5 points): Major impact on entire business
   - Medium (3 points): Impact on specific areas
   - Low (1 point): Limited impact

3. **Urgency**
   - High (5 points): Immediate response required
   - Medium (3 points): Medium-term preparation needed
   - Low (1 point): Long-term monitoring sufficient

## TOWS Matrix Strategy Development

{{#if strategy_focus}}
### Strategic Focus: {{strategy_focus}}
{{/if}}

{{#switch strategy_focus}}
{{#case "SO"}}
### SO Strategy (Aggressive)
**Leverage strengths to maximize opportunities**
- Market expansion strategy
- New product/service development
- Aggressive investment and deployment
{{/case}}
{{#case "WO"}}
### WO Strategy (Turnaround)
**Leverage opportunities to improve weaknesses**
- Partnership and collaboration strategy
- Capability development and talent acquisition
- Phased improvement approach
{{/case}}
{{#case "ST"}}
### ST Strategy (Diversification)
**Leverage strengths to address threats**
- Differentiation strategy
- Focus on niche markets
- Defensive positioning
{{/case}}
{{#case "WT"}}
### WT Strategy (Defensive/Retreat)
**Minimize weaknesses and avoid threats**
- Enhanced risk management
- Business downsizing/exit consideration
- Cost reduction and efficiency
{{/case}}
{{#case "balanced"}}
### Balanced Strategy
**Combine four strategies according to situation**
1. **Growth areas**: Aggressive expansion with SO strategy
2. **Improvement areas**: Capability building with WO strategy
3. **Defense areas**: Maintain advantage with ST strategy
4. **Retreat areas**: Minimize risk with WT strategy
{{/case}}
{{/switch}}

## Prioritization Methods

{{#if prioritization_method}}
### Selected Method: {{prioritization_method}}
{{/if}}

{{#switch prioritization_method}}
{{#case "impact_effort"}}
### Impact-Effort Matrix
```
High Impact/Low Effort → Top Priority
High Impact/High Effort → Planned Implementation
Low Impact/Low Effort → Implement if Resources Allow
Low Impact/High Effort → Do Not Implement
```
{{/case}}
{{#case "weighted_score"}}
### Weighted Scoring
1. Assign weights to evaluation criteria (total 100%)
2. Evaluate each item by criteria (1-5 points)
3. Determine ranking by sum of weight × score
{{/case}}
{{#case "voting"}}
### Voting-based Prioritization
1. Voting by stakeholders
2. Two-axis evaluation of importance/urgency
3. Consensus building process
{{/case}}
{{/switch}}

{{#if time_frame}}
## Time Horizon Consideration
**Analysis Period**: {{time_frame}}

- **Immediate action items**: Start within 3 months
- **Short-term plan items**: Implement within 6 months to 1 year
- **Medium/long-term items**: Planned approach over 1+ years
{{/if}}

## Analysis Templates

### SWOT Analysis Sheet
```
┌─────────────────┬─────────────────┐
│  Strengths (S)  │  Weaknesses (W) │
├─────────────────┼─────────────────┤
│ 1.              │ 1.              │
│ 2.              │ 2.              │
│ 3.              │ 3.              │
│ 4.              │ 4.              │
│ 5.              │ 5.              │
├─────────────────┼─────────────────┤
│ Opportunities(O)│  Threats (T)    │
├─────────────────┼─────────────────┤
│ 1.              │ 1.              │
│ 2.              │ 2.              │
│ 3.              │ 3.              │
│ 4.              │ 4.              │
│ 5.              │ 5.              │
└─────────────────┴─────────────────┘
```

### TOWS Matrix
```
             │ Opportunities │  Threats
─────────────┼──────────────┼──────────────
Strengths    │ SO Strategy  │ ST Strategy
             │ Aggressive   │ Diversify
─────────────┼──────────────┼──────────────
Weaknesses   │ WO Strategy  │ WT Strategy
             │ Turnaround   │ Defensive
```

## Implementation Considerations

1. **Ensuring Objectivity**
   - Verification from multiple perspectives
   - Data-based substantiation
   - Distinction between wishes and reality

2. **Dynamic Updates**
   - Regular reviews (quarterly to semi-annually)
   - Adaptation to environmental changes
   - Incorporation of new information

3. **Feasibility**
   - Realistic resource assessment
   - Consideration of implementation structure
   - Phased approach

## Output Examples

### Executive Summary Format
1. **Current Situation** (1 paragraph)
2. **Key SWOT Elements** (3-5 bullet points each)
3. **Strategic Recommendations** (3-5 items)
4. **Priority Actions** (Immediate/Short-term/Medium-term)
5. **Expected Outcomes and KPIs**

### Detailed Report Format
1. **Executive Summary** (1 page)
2. **Background and Purpose of Analysis** (1 page)
3. **Detailed SWOT Analysis** (4-6 pages)
4. **TOWS Matrix and Strategic Options** (2-3 pages)
5. **Implementation Plan and Roadmap** (2-3 pages)
6. **Risks and Countermeasures** (1 page)
7. **Appendix: Data and Supporting Materials**