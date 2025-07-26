# Data Analysis
## Analysis Target
- **Analysis Purpose**: {{analysis_purpose}}
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
{{/data_collection_target}}{{/data_location}}
## CRISP-DM Compliant Analysis Process
Business Understanding
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
Data Collection (When Necessary)
{{#data_collection_target}}
#### Collection Planning
1. **Identifying Information Sources**
2. **Collection Execution**
3. **Data Structuring**
{{/data_collection_target}}
Data Understanding (Exploratory Data Analysis)
#### Initial Data Exploration
1. **Understanding Data Overview**
2. **Descriptive Statistics**
3. **Visual Exploration**
Data Preparation
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
Analysis Method Application
#### Statistical Analysis Methods
{{#analysis_methods}}
- {{analysis_methods}}
{{/analysis_methods}}
{{^analysis_methods}}
1. **Descriptive Analysis**
2. **Inferential Statistics**
3. **Predictive Analysis**
{{/analysis_methods}}
Insight Extraction and Visualization
#### Data Visualization Principles
1. **Understanding the Audience**
2. **Visualization Selection**
3. **Storytelling**
#### Key Findings
- Identifying patterns and trends
- Explaining anomalies and outliers
- Distinguishing causation and correlation
Result Evaluation and Reporting
#### Analysis Result Validation
- Confirming statistical significance
- Evaluating practical significance
- Clearly stating limitations and caveats
#### Report Structure
1. **Executive Summary**
2. **Detailed Analysis**
3. **Visual Dashboard**
## Quality Assurance and Best Practices