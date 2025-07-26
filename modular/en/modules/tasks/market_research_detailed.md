# Market Research Module

## Overview

This module provides a comprehensive framework and guidelines for conducting systematic and thorough market research.

## Prerequisites

- **Variables**: `{{INDUSTRY}}`, `{{TARGET_MARKET}}`, `{{PRODUCT_CATEGORY}}`, `{{ANALYSIS_SCOPE}}`
- **Required Knowledge**: Basic business analysis skills, data interpretation capabilities
- **Recommended Tools**: Market research databases, analytics software, social listening tools

## 1. Market Research Purpose and Scope

### 1.1 Clarifying Research Objectives
```yaml
objectives:
  primary:
    - Evaluate market size and growth potential
    - Analyze competitive landscape
    - Understand customer needs
    - Identify market entry opportunities
  secondary:
    - Understand regulatory environment
    - Analyze technology trends
    - Identify risk factors
```

### 1.2 Setting Research Scope
- **Geographic Scope**: Market characteristics in {{TARGET_MARKET}}
- **Temporal Scope**: Past 3-5 years trends and next 3-5 years forecast
- **Product/Service Scope**: All categories related to {{PRODUCT_CATEGORY}}

## 2. Market Size Analysis (TAM/SAM/SOM)

### 2.1 TAM (Total Addressable Market)
```
TAM = [Total Potential Customers] × [Average Price] × [Purchase Frequency]
```

**Analysis Methods**:
1. Top-Down Analysis
   - Market size data from industry reports
   - Utilization of government statistics
   - Correlation analysis with macroeconomic indicators

2. Bottom-Up Analysis
   - Aggregation by customer segment
   - Regional market compilation
   - Estimation by product category

### 2.2 SAM (Serviceable Addressable Market)
```
SAM = TAM × [Geographic Coverage Rate] × [Technical Fit Rate] × [Regulatory Compliance Rate]
```

**Considerations**:
- Compatibility with business model
- Technical constraints and feasibility
- Regulatory and legal constraints
- Distribution channel accessibility

### 2.3 SOM (Serviceable Obtainable Market)
```
SOM = SAM × [Realistic Market Share Target] × [Execution Capability Factor]
```

**Evaluation Criteria**:
- Competitor market share analysis
- Company competitive advantage assessment
- Resource constraint considerations
- Market entry timing impact

## 3. Competitive Environment Analysis (Porter's Five Forces)

### 3.1 Threat of New Entrants
**Evaluation Items**:
- Height of entry barriers
  - Initial investment amount
  - Economies of scale
  - Brand importance
  - Regulatory/licensing requirements
- Prediction of incumbent reactions
- Technical entry barriers

### 3.2 Threat of Substitutes
**Analysis Framework**:
```yaml
substitution_analysis:
  direct_substitutes:
    - Different products meeting same needs
    - Price-performance comparison
  indirect_substitutes:
    - Products meeting needs differently
    - Future substitution potential
```

### 3.3 Bargaining Power of Buyers
**Evaluation Metrics**:
- Customer concentration
- Switching costs
- Price sensitivity
- Information asymmetry

### 3.4 Bargaining Power of Suppliers
**Checklist**:
- [ ] Supplier concentration and substitutability
- [ ] Importance of raw materials/components
- [ ] Forward integration threat
- [ ] Switching cost evaluation

### 3.5 Rivalry Among Existing Competitors
**Competition Intensity Matrix**:
```
High │ Price War    │ Innovation Race
     │──────────────┼─────────────────
Comp │ Stable       │ Niche Market
Inte │ Competition  │ Formation
nsity│              │
Low  │──────────────┴─────────────────
     Low         Differentiation      High
```

## 4. Macro Environment Analysis (PESTLE)

### 4.1 Political Factors
- Government policy trends and regulatory changes
- Trade policies and international relations
- Political stability and risks
- Government support for {{INDUSTRY}}

### 4.2 Economic Factors
```yaml
economic_indicators:
  macro:
    - GDP growth rate
    - Inflation rate
    - Exchange rate trends
    - Interest rate levels
  industry_specific:
    - Industry growth rate
    - Investment trends
    - Profitability trends
```

### 4.3 Social Factors
- Demographic changes
- Lifestyle changes
- Evolution of consumer values
- Education levels and skills

### 4.4 Technological Factors
**Technology Assessment Framework**:
1. Identification of disruptive technologies
2. Technology adoption curve analysis
3. R&D investment trends
4. Impact of digitalization

### 4.5 Legal Factors
- Industry-specific regulations
- Intellectual property rights
- Labor laws
- Consumer protection laws

### 4.6 Environmental Factors
- Strengthening environmental regulations
- Sustainability requirements
- Climate change impacts
- Resource constraints

## 5. Customer Analysis

### 5.1 Customer Segmentation
```yaml
segmentation_criteria:
  demographic:
    - Age, gender, income
    - Region, city size
  psychographic:
    - Lifestyle
    - Values, attitudes
  behavioral:
    - Purchase patterns
    - Brand loyalty
    - Usage frequency
```

### 5.2 Customer Needs Analysis
**Jobs-to-be-Done Framework**:
1. Functional Jobs: Specific problems to solve
2. Emotional Jobs: Feelings to experience
3. Social Jobs: How others perceive them

### 5.3 Customer Journey Mapping
```
Awareness → Consideration → Purchase → Usage → Advocacy
    ↓            ↓            ↓         ↓         ↓
Touchpoints  Touchpoints  Touchpoints Points  Points
Pain Points  Pain Points  Pain Points Points  Points
```

## 6. Digital Market Research Methods

### 6.1 Social Listening
**Analysis Items**:
- Brand mention volume and sentiment
- Competitive comparison analysis
- Trend topic identification
- Influencer analysis

### 6.2 Web Analytics
```yaml
web_analytics:
  traffic_analysis:
    - Search volume analysis
    - Competitor site traffic
    - Conversion rate benchmarking
  seo_analysis:
    - Keyword competitiveness
    - Content gap analysis
```

### 6.3 Online Research
- Survey design and implementation
- A/B testing for hypothesis validation
- Heatmap analysis
- Usability testing

## 7. Competitive Intelligence

### 7.1 Competitor Profiling
**Analysis Template**:
```yaml
competitor_profile:
  basic_info:
    - Company size, revenue
    - Market share
    - Key products/services
  strategy:
    - Positioning
    - Pricing strategy
    - Marketing strategy
  capabilities:
    - Technical capabilities
    - Financial strength
    - Human resources
```

### 7.2 Competitive Benchmarking
- Product/service comparison matrix
- Price positioning analysis
- Customer satisfaction comparison
- Innovation capability assessment

## 8. Market Forecasting and Scenario Analysis

### 8.1 Trend Analysis
```
Historical Data → Current Situation → Future Forecast
       ↓                ↓                  ↓
  Causal Links    Change Factors      Scenarios
```

### 8.2 Scenario Planning
**Scenario Matrix**:
```
High     │ Base Case  │ Growth Scenario
Certainty│            │
         │            │
Uncert-  │ Stagnation │ Disruptive
ainty    │ Scenario   │ Scenario
Factors  │            │
Low      │────────────┴────────────────
         Pessimistic Impact Optimistic
```

## 9. Market Entry Strategy Development

### 9.1 SWOT Analysis
```yaml
swot_matrix:
  strengths:
    - Internal strengths
    - Competitive advantages
  weaknesses:
    - Internal weaknesses
    - Areas needing improvement
  opportunities:
    - External opportunities
    - Growth potential
  threats:
    - External threats
    - Risk factors
```

### 9.2 Strategic Option Evaluation
1. **Market Penetration Strategy**
   - Share expansion in existing markets
   - Pricing strategy, promotion enhancement

2. **Market Development Strategy**
   - Expansion to new regions/segments
   - Channel expansion

3. **Product Development Strategy**
   - New product/service introduction
   - Innovation promotion

4. **Diversification Strategy**
   - New market × New product
   - Risk diversification

## 10. Implementation Plan and KPI Setting

### 10.1 Action Plan
```yaml
action_plan:
  phase1_research:
    duration: "1-2 months"
    activities:
      - Conduct secondary research
      - Competitive analysis
      - Initial hypothesis building
  phase2_validation:
    duration: "2-3 months"
    activities:
      - Conduct primary research
      - Customer interviews
      - Hypothesis validation
  phase3_strategy:
    duration: "1 month"
    activities:
      - Strategy development
      - Execution plan creation
```

### 10.2 KPI Setting
**Example Metrics**:
- Market share targets
- Customer Acquisition Cost (CAC)
- Customer Lifetime Value (LTV)
- Revenue growth rate
- Customer satisfaction score

## Important Notes

1. **Data Reliability**: Verify from multiple sources
2. **Bias Avoidance**: Beware of confirmation bias, selection bias
3. **Continuous Updates**: Regular reviews needed as markets constantly change
4. **Ethical Considerations**: Competitive information gathering through legal and ethical means

## References

- Porter, M. E. (2008). "The Five Competitive Forces That Shape Strategy"
- Ries, E. (2011). "The Lean Startup"
- Christensen, C. M. (1997). "The Innovator's Dilemma"
- Various industry reports, government statistical databases