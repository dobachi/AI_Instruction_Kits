# Claude Code Agent Usage Guide

## What is Task tool?
An autonomous task processing feature provided by Claude Code. Can execute complex investigations and analyses without detailed instructions.

## Effective Use Cases

### ✅ Suitable for Agent
- **Large-scale Investigation**: Cross-file analysis across many files
- **Pattern Detection**: Comprehensive search for specific patterns in code
- **Impact Analysis**: Comprehensive investigation of change impacts
- **Documentation Verification**: Consistency check between implementation and documentation

### ❌ Not Suitable for Agent
- Simple edits to single files
- Tasks with clear, defined procedures
- Work requiring real-time interaction

## Practical Examples

### Code Quality Investigation
```
"Find all TODO comments across the project and list them by priority"
"Identify functions exceeding 100 lines and report with complexity metrics"
```

### Dependency Analysis
```
"Detect all unused imports"
"Identify all locations using this class"
```

### Security Audit
```
"Check for any hardcoded credentials"
"Find potential SQL injection vulnerabilities"
```

### Test Analysis
```
"Identify all untested public functions"
"List modules with test coverage below 50%"
```

## Writing Effective Prompts

### Good Example
```
✅ "Find duplicate functions in the src directory and suggest consolidation methods"
- Clear scope (src directory)
- Specific purpose (duplicate detection)
- Expected outcome (consolidation suggestions)
```

### Poor Example
```
❌ "Improve the code"
- Unclear scope
- Ambiguous purpose
- Undefined outcome
```

## Execution Tips

### 1. Incremental Approach
Start small and expand scope after success:
```
1. "Find unused functions in utils folder"
2. "Find unused functions in entire src"
3. "Find unused functions in entire project"
```

### 2. Specify Output Format
```
"Output results in JSON format"
"Organize in Markdown table"
"Sort by priority"
```

### 3. Set Constraints
```
"Report maximum 10 items"
"Target high priority only"
"Analyze only changes from last week"
```

## Troubleshooting

### Task Takes Too Long
→ Narrow scope or limit file count

### Memory Error
→ Split processing and execute incrementally

### Unexpected Results
→ Provide more specific conditions or examples

---
## License Information
- **License**: Apache-2.0
- **Created**: 2025-01-13