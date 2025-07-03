# Checkpoint Management System (Flexible Configuration)

## Purpose
Track and report task progress concisely and consistently

## Basic Rules
**[CRITICAL] Execute the following in every response:**

1. **Always execute `scripts/checkpoint.sh` at the very beginning and display its 2-line output**
   - Execute without exception in all responses
   - Mandatory for answering questions, code generation, analysis, and all tasks
   - AI response quality is considered degraded if script execution is forgotten

2. **Task start/error/completion are automatically logged to file**

## Script Usage

### Task Start
```bash
scripts/checkpoint.sh start <task-id> <task-name> <total-steps>
# Example: scripts/checkpoint.sh start TASK-abc123 "Web app development" 5
```

### Progress Report
```bash
scripts/checkpoint.sh progress <current-step> <total-steps> <status> <next-action>
# Example: scripts/checkpoint.sh progress 2 5 "Implementation done" "Create tests"
```

### Error Occurrence
```bash
scripts/checkpoint.sh error <task-id> <error-message>
# Example: scripts/checkpoint.sh error TASK-abc123 "Dependency error"
```

### Task Completion
```bash
scripts/checkpoint.sh complete <task-id> <result>
# Example: scripts/checkpoint.sh complete TASK-abc123 "3 APIs, 10 tests created"
```

## Implementation Example

```
# Task start
$ scripts/checkpoint.sh start TASK-7f9a2b "Python function implementation" 4
`[1/4] Started | Next: Analysis`
`📌 Log→checkpoint.log: [2025-07-03 19:00:00][TASK-7f9a2b][START] Python function implementation (4 steps estimated)`

# Progress report
$ scripts/checkpoint.sh progress 2 4 "Implementation done" "Create tests"
`[2/4] Implementation done | Next: Create tests`
`📌 Log→checkpoint.log: Log only at start/error/completion`

# Task completion
$ scripts/checkpoint.sh complete TASK-7f9a2b "1 function, 3 tests"
`[✓] All done | Result: 1 function, 3 tests`
`📌 Log→checkpoint.log: [2025-07-03 19:05:00][TASK-7f9a2b][COMPLETE] Result: 1 function, 3 tests`
```

## Important Notes

1. **Task ID generation**: 6-character alphanumeric (e.g., 7f9a2b)
2. **Keep it concise**: Status and actions should be short and clear
3. **Maintain consistency**: Use the same task ID and step count for the same task
4. **Path awareness**: `scripts/checkpoint.sh` is a relative path from project root

## Integration with Other Instructions

This checkpoint management is used in combination with all instruction sheets.
Execute `scripts/checkpoint.sh` for each major step in the instructions.

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created**: 2025-06-30
- **Updated**: 2025-07-03