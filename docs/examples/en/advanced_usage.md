# Advanced Usage Examples

This document demonstrates advanced usage of the AI Instruction Manager.

## 1. Creating Custom Instructions

How to create project-specific instruction sheets.

### Creating from Template

```bash
# Copy and edit template
cp templates/instruction_template.md instructions/en/custom/my_project_rules.md

# Use custom instruction
claude "Refer to instructions/en/custom/my_project_rules.md 
and refactor according to project coding standards"
```

### Custom Instruction Example

```markdown
# Project-Specific Coding Standards

## Purpose
Follow coding standards and best practices specific to this project

## Specific Instructions
1. Add type annotations to all functions
2. Always wrap error handling in try-except
3. Use dedicated logger for log output
4. Maintain test coverage above 80%

## License Information
- **License**: Proprietary
- **Original Author**: Project Team
- **Created**: 2025-06-30
```

## 2. Complex Tasks with Conditionals

```bash
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md 
and implement API based on the following conditions:
- If authentication required, implement JWT auth
- If caching needed, use Redis
- If rate limiting needed, limit to 60 requests per minute"
```

Expected behavior:
```
`[1/5] Requirements analysis complete | Next: API design`
`📌 Log→checkpoint.log: [2025-06-30 12:00:00][TASK003][START] Conditional API implementation (5 steps)`

Analyzed requirements and determined the following implementations are needed:
- JWT authentication: Required
- Redis cache: Required
- Rate limiting: Required

`[2/5] API design complete | Next: Auth implementation`
`📌 Log→checkpoint.log: Log only at start/error/completion`
```

## 3. Integration with Existing Codebase

```bash
# Understand existing project structure before implementation
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md and:
1. First analyze existing code structure
2. Identify existing patterns and conventions
3. Implement new features following those patterns"
```

## 4. Incremental Feature Addition

```bash
# Development across multiple sessions
# Session 1
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md 
and implement basic CRUD API.
Record completion in checkpoint.log"

# Session 2 (later)
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md,
check checkpoint.log, and continue from previous work
by adding authentication features"
```

## 5. Debugging and Troubleshooting

```bash
# Detailed error investigation
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md and:
1. Analyze error logs
2. Identify root cause
3. Propose fixes
4. Implement corrections
5. Verify with tests"
```

Expected behavior:
```
`[1/5] Analyzing logs | Next: Identify cause`
`📌 Log→checkpoint.log: [2025-06-30 13:00:00][TASK004][START] Error investigation (5 steps)`

Checking error logs...

`[2/5] Cause identified | Next: Create fix proposal`
`📌 Log→checkpoint.log: Log only at start/error/completion`

NullPointerException cause: Object reference before initialization

`[3/5] Fix proposal complete | Next: Implementation`
`📌 Log→checkpoint.log: Log only at start/error/completion`
```

## 6. Performance Optimization

```bash
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md and:
1. Identify current performance bottlenecks
2. Determine optimization priorities
3. Implement optimizations incrementally
4. Run benchmarks at each stage"
```

## 7. Multi-language Support

```bash
# Create instruction sheets in both Japanese and English
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md 
and create new instruction sheet with both Japanese and English versions"
```

## Best Practices

1. **Clear Task Definition**: Clearly defining tasks ensures appropriate instruction selection
2. **Incremental Execution**: Break large tasks into smaller steps
3. **Error Handling**: Consider error handling approaches beforehand
4. **Log Utilization**: Use checkpoint.log to track progress
5. **Customization**: Customize instructions according to project-specific requirements

---
## License Information
- **License**: Apache-2.0
- **Original Author**: dobachi
- **Created**: 2025-06-30