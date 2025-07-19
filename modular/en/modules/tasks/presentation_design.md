# Presentation Design Task Module

## Task Overview

Design and create visually appealing and professional presentations that clearly communicate your message.

## Fundamental Principles of Presentation Design

### 1. Purpose and Audience Analysis

- **Presentation Purpose**: {{presentation_purpose}}
- **Expected Duration**: {{presentation_duration}}
{{#delivery_format}}
- **Delivery Format**: {{delivery_format}}
{{/delivery_format}}

#### Key Points for Audience Analysis
- Participants' background knowledge and expertise level
- Decision-making roles and influence
- Expected outcomes and behavioral changes
- Cultural background and language considerations

### 2. Storytelling and Structure

#### Effective Structure Frameworks

{{#presentation_type}}
{{#eq presentation_type "Sales presentation"}}
##### Sales Presentation Structure
1. **Problem Statement** - Clarify customer pain points
2. **Solution Proposal** - Present the solution
3. **Value Demonstration** - ROI and benefits
4. **Call to Action** - Next steps
{{/eq}}
{{#eq presentation_type "Conference presentation"}}
##### Conference Presentation Structure
1. **Hook** - Engaging introduction
2. **Background and Context** - Why this topic matters
3. **Key Insights** - New findings or discoveries
4. **Practical Applications** - How audience can apply
5. **Future Outlook** - Possibilities ahead
{{/eq}}
{{#eq presentation_type "Board presentation"}}
##### Board Presentation Structure
1. **Executive Summary** - Conclusion first
2. **Current State Analysis** - Data-driven situation
3. **Proposal Details** - Specific actions
4. **Risks and Mitigation** - Potential challenges
5. **Required Resources** - Budget and personnel
6. **Expected Outcomes** - KPIs and timeline
{{/eq}}
{{/presentation_type}}

{{^presentation_type}}
##### Standard Business Presentation Structure
1. **Introduction** - Purpose and agenda
2. **Current State** - Background and challenges
3. **Proposal/Solution** - Main content
4. **Implementation Plan** - Concrete steps
5. **Summary** - Key points recap
6. **Q&A** - Interaction time
{{/presentation_type}}

### 3. Visual Design Principles

#### Establishing Visual Hierarchy

1. **Clear Headings**
   - Main heading: 36-44pt
   - Subheading: 28-32pt
   - Body text: 24-28pt (minimum 24pt)

2. **Color Design**
{{#brand_guidelines}}
   - Brand Guidelines: {{brand_guidelines}}
{{/brand_guidelines}}
{{^brand_guidelines}}
   - Primary colors: 1-2 colors (brand colors)
   - Accent color: 1 color (attention-grabbing elements)
   - Background color: Neutral tones
   - Contrast ratio: WCAG AA level or higher (4.5:1)
{{/brand_guidelines}}

3. **Layout Consistency**
   - Grid system adoption
   - Strategic use of white space
   - Unified alignment (left/center)

#### Slide Design Best Practices

1. **One Message Per Slide Principle**
   - Clear core message for each slide
   - Avoid information overload

2. **Visual-First Approach**
   - Prioritize diagrams over text
   - Use high-quality images and icons
   - Eliminate unnecessary decorative elements

3. **Ensuring Readability**
   - Sufficient contrast
   - Appropriate line spacing (1.5x or more)
   - Short sentences and keyword focus

### 4. Data Visualization

#### Chart Selection Guide

1. **For Comparisons**
   - Bar chart: Category comparisons
   - Horizontal bar chart: Many items comparison
   - Radar chart: Multi-dimensional comparison

2. **For Trends**
   - Line chart: Time-series changes
   - Area chart: Cumulative value changes
   - Sparkline: Small trend display

3. **For Composition**
   - Pie chart: Proportion to whole (5 items or less)
   - Donut chart: Central value placement
   - Treemap: Hierarchical composition

4. **For Correlations**
   - Scatter plot: Two-variable relationship
   - Bubble chart: Three-variable relationship
   - Heatmap: Multi-variable correlation

#### Data Display Principles
- Maximize data-ink ratio
- Remove unnecessary gridlines
- Use direct labeling
- Consider color blindness

### 5. Animation and Transitions

#### Effective Animation Usage

1. **Purposeful Animation**
   - Progressive information disclosure
   - Attention guidance
   - Process visualization

2. **Subtle Transitions**
   - Fade in/out: Most natural
   - Slide: When showing direction
   - Zoom: Focus on details

3. **Effects to Avoid**
   - Excessive rotation or bounce
   - Random transitions
   - Overuse of sound effects

### 6. Speaker Notes Creation

#### Effective Note Structure

1. **Key Points Documentation**
   - Core message for each slide
   - Essential statistics and facts
   - Transitions to next slide

2. **Timing Instructions**
   - Duration for each section
   - Interaction timing
   - Points to prompt questions

3. **Backup Information**
   - Anticipated Q&A
   - Additional examples and data
   - Technical details

### 7. Accessibility Compliance

{{#accessibility_requirements}}
#### Special Considerations
- {{accessibility_requirements}}
{{/accessibility_requirements}}

#### Standard Accessibility Measures

1. **Visual Considerations**
   - Sufficient contrast ratio (AA standard or higher)
   - Information not conveyed by color alone
   - Readable font sizes
   - Alternative text provision

2. **Auditory Considerations**
   - Captions for audio content
   - Visual cues usage
   - Advance material distribution

3. **Cognitive Considerations**
   - Clear structure and navigation
   - Plain language usage
   - Summaries and recaps

### 8. Handout Preparation

#### Print Material Optimization
- 3 slides per page layout
- Note-taking space
- Monochrome print compatibility
- Page numbering

#### Digital Distribution Considerations
- PDF protection settings
- File size optimization
- Hyperlink verification
- Proper metadata settings

### 9. Presentation Delivery Checklist

#### Pre-event Preparation
- [ ] Technical functionality check
- [ ] Backup preparation
- [ ] Time allocation confirmation
- [ ] Handout printing/sharing

#### Day-of Checklist
- [ ] Equipment connection and testing
- [ ] Lighting and audio check
- [ ] Remote control functionality
- [ ] Water and notes ready

{{#cultural_context}}
#### Cultural Considerations
- {{cultural_context}}
- Appropriate greetings and etiquette
- Gesture cultural differences
- Time perception variations
{{/cultural_context}}

### 10. Deliverable Quality Standards

#### Design Quality
- Brand guideline compliance
- Visual consistency and harmony
- Professional impression

#### Content Quality
- Message clarity
- Logical structure
- Appropriate information volume

#### Technical Quality
- Compatibility assurance
- File size optimization
- Animation smoothness

Following these standards ensures the creation of effective and professional presentations.