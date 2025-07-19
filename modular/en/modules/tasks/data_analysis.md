# Data Analysis Task Module

## Task Overview

Extract meaningful insights from data through systematic data analysis to support decision-making.

## Analysis Target

- **Analysis Purpose**: {{analysis_purpose}}

### Data Source Identification

{{#data_location}}
#### Using Existing Data
- **Data Location**: {{data_location}}
- **Data Description**: {{data_description}}
{{/data_location}}

{{#data_collection_target}}
#### Analysis from Data Collection
- **Collection Target**: {{data_collection_target}}
{{#collection_methods}}
- **Collection Methods**: {{collection_methods}}
{{/collection_methods}}
{{/data_collection_target}}

{{^data_location}}{{^data_collection_target}}
#### Data Source Decision
Based on the analysis purpose, consider data sources in the following priority:
1. Existing available data (local files, databases, APIs)
2. Public datasets (government statistics, research data, open data)
3. New data collection (web scraping, surveys, experiments)
{{/data_collection_target}}{{/data_location}}

## CRISP-DM Compliant Analysis Process

### 1. Business Understanding

#### Setting Analysis Goals
- Alignment of business and analysis objectives
- Clarifying success criteria
- Identifying constraints and assumptions

#### Expected Outcomes
{{#expected_outcomes}}
- {{expected_outcomes}}
{{/expected_outcomes}}
{{^expected_outcomes}}
- Extraction of actionable insights
- Data-driven recommendations
- Decision support information
{{/expected_outcomes}}

### 2. Data Collection (When Necessary)

{{#data_collection_target}}
#### Collection Planning
1. **Identifying Information Sources**
   - Research reliable data sources
   - Confirm accessibility
   - Verify legal and ethical constraints

2. **Collection Execution**
   - Systematic data acquisition
   - Metadata recording
   - Quality checks

3. **Data Structuring**
   - Conversion to unified format
   - Initial cleaning
   - Storage and management
{{/data_collection_target}}

### 3. Data Understanding (Exploratory Data Analysis)

#### Initial Data Exploration
1. **Understanding Data Overview**
   - Data scale and structure
   - Variable types and meanings
   - Initial data quality assessment

2. **Descriptive Statistics**
   - Central tendency (mean, median, mode)
   - Variability (standard deviation, interquartile range)
   - Distribution shape (skewness, kurtosis)

3. **Visual Exploration**
   - Histograms and density plots
   - Scatter plots and pair plots
   - Box plots and outlier detection

### 4. Data Preparation

#### Data Cleansing
- Missing value handling strategies
- Outlier identification and treatment
- Data type consistency verification

#### Feature Engineering
{{#feature_engineering}}
- {{feature_engineering}}
{{/feature_engineering}}
{{^feature_engineering}}
- Creating derived variables
- Categorical variable encoding
- Scaling and normalization
{{/feature_engineering}}

### 5. Analysis Method Application

#### Statistical Analysis Methods
{{#analysis_methods}}
- {{analysis_methods}}
{{/analysis_methods}}
{{^analysis_methods}}
1. **Descriptive Analysis**
   - Cross-tabulation
   - Correlation analysis
   - Time series analysis

2. **Inferential Statistics**
   - Hypothesis testing
   - Confidence interval estimation
   - Effect size calculation

3. **Predictive Analysis**
   - Regression analysis
   - Classification analysis
   - Clustering
{{/analysis_methods}}

### 6. Insight Extraction and Visualization

#### Data Visualization Principles
1. **Understanding the Audience**
   - Considering technical background
   - Determining required detail level
   - Providing context

2. **Visualization Selection**
   - Choosing appropriate charts for data types
   - Color usage and accessibility
   - Interactive element utilization

3. **Storytelling**
   - Building narratives from data
   - Emphasizing key findings
   - Actionable recommendations

#### Key Findings
- Identifying patterns and trends
- Explaining anomalies and outliers
- Distinguishing causation and correlation

### 7. Result Evaluation and Reporting

#### Analysis Result Validation
- Confirming statistical significance
- Evaluating practical significance
- Clearly stating limitations and caveats

#### Report Structure
1. **Executive Summary**
   - Key insights (3-5 items)
   - Recommended actions
   - Expected impact

2. **Detailed Analysis**
   - Methodology explanation
   - Analysis process documentation
   - Technical details provision

3. **Visual Dashboard**
   - Interactive exploration
   - Real-time updates (when applicable)
   - Drill-down capabilities

## Quality Assurance and Best Practices

### Data Governance
{{#data_governance}}
- {{data_governance}}
{{/data_governance}}
{{^data_governance}}
- Data privacy protection
- Bias identification and mitigation
- Ensuring transparency
{{/data_governance}}

### Reproducibility
- Analysis code documentation
- Data processing procedure recording
- Version control implementation

### Continuous Improvement
- Establishing feedback loops
- Regular model updates
- Integration of new data sources

---