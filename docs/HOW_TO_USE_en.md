# AI Instruction Repository Usage Guide (For Humans)

This document is a guide for users (humans) of this repository.

## Basic Usage

### 1. Simple Usage

The easiest way is to tell the AI the path of the required instruction:

```
"Refer to instructions/en/coding/basic_code_generation.md 
and write Python code to generate Fibonacci sequence"
```

### 2. Using ROOT_INSTRUCTION

ROOT_INSTRUCTION.md makes the AI behave as an instruction manager:

```
"Refer to ROOT_INSTRUCTION_en.md 
and analyze sales data to create a report"
```

The AI will automatically:
- Load analysis/basic_data_analysis.md (for data analysis)
- Load writing/basic_text_creation.md (for report creation)
and execute them.

### 3. Using INSTRUCTION_SELECTOR

Use optimized combinations for specific use cases:

```
"Refer to INSTRUCTION_SELECTOR_en.md 
and implement a RESTful API 
as a web application development task"
```

## Use Case Guides

### Data Analysis Project
```
Required files:
- ROOT_INSTRUCTION_en.md or INSTRUCTION_SELECTOR_en.md
- Data files

Example:
"Apply the data science task rules from INSTRUCTION_SELECTOR_en.md 
to analyze sales_data.csv and summarize insights"
```

### Content Creation
```
Required files:
- instructions/en/writing/basic_text_creation.md
- instructions/en/creative/basic_creative_work.md

Example:
"Refer to the above instructions 
and create an article about the future of AI"
```

## Customization

### Adding New Instructions

1. Copy template:
   ```bash
   cp templates/en/instruction_template.md instructions/en/[category]/my_instruction.md
   ```

2. Edit content

3. Add to ROOT_INSTRUCTION_en.md (optional)

### Adding Organization-Specific Rules

Create instructions/en/general/company_rules.md 
and include internal rules and coding standards.

## Best Practices

1. **Start Minimal**
   - Begin with minimum necessary instructions, add as needed

2. **Clear Specification**
   - Specify file paths accurately
   - Clearly communicate task objectives

3. **Feedback Loop**
   - Review results and improve instructions as needed

## Troubleshooting

### When AI doesn't work as expected

1. Verify specified file paths are correct
2. Add more specific instructions
3. Explicitly specify multiple instructions if needed

### Performance Issues

- Loading many instructions may slow processing
- Consider using only necessary excerpts

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created Date**: 2025-06-30