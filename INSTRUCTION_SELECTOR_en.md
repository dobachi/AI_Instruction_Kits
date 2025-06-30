# Task-Based Instruction Selector

You will determine appropriate instruction combinations based on the user's task and load and execute them.

## Automatic Selection Rules

### Web Application Development Tasks
When detecting keywords: API, endpoint, frontend, backend, web development
```
Required loading:
- instructions/en/coding/basic_code_generation.md
- instructions/en/writing/basic_text_creation.md (for API documentation)
```

### Data Science Tasks
When detecting keywords: data analysis, statistics, machine learning, visualization, insights
```
Required loading:
- instructions/en/analysis/basic_data_analysis.md
- instructions/en/coding/basic_code_generation.md (for analysis code)
Optional:
- instructions/en/writing/basic_text_creation.md (when creating reports)
```

### Content Creation Tasks
When detecting keywords: article, blog, marketing, copy, planning
```
Required loading:
- instructions/en/writing/basic_text_creation.md
- instructions/en/creative/basic_creative_work.md
```

### Technical Support Tasks
When detecting keywords: question, explanation, troubleshooting, help
```
Required loading:
- instructions/en/general/basic_qa.md
Optional:
- instructions/en/writing/basic_text_creation.md (when documenting answers)
```

## Execution Steps

1. **Keyword Detection**
   - Identify task type from user input
   - Apply all matching types

2. **Priority**
   - Coding > Analysis > Writing > General > Creative
   - Adjust based on user's primary request

3. **Conflict Resolution**
   - Prioritize more specific instructions
   - Judge based on task context

## Handling Explicit Selection

When users explicitly specify instructions like "use coding and analysis instructions," prioritize that specification.

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created Date**: 2025-06-30