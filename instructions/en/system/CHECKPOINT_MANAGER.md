# Checkpoint Management System (Flexible Configuration)

## Purpose
Track and report task progress concisely and consistently

## Basic Rules
**[CRITICAL] Execute the following in every response:**

1. **Always execute `scripts/checkpoint.sh pending` at the very beginning and display its output**
   - Execute without exception in all responses
   - Mandatory for answering questions, code generation, analysis, and all tasks
   - AI response quality is considered degraded if script execution is forgotten

2. **Task start/error/completion are automatically logged to file**

## Script Usage

### Task Start
```bash
scripts/checkpoint.sh start <task-name> <total-steps>
# Example: scripts/checkpoint.sh start "Web app development" 5
# → Task ID: TASK-123456-abc123 will be auto-generated
```

### Progress Report
```bash
scripts/checkpoint.sh progress <task-id> <current-step> <total-steps> <status> <next-action>
# Example: scripts/checkpoint.sh progress TASK-123456-abc123 2 5 "Implementation done" "Create tests"
```
**Note**: Progress reporting is only possible while using instructions (workflow constraint)

### Error Occurrence
```bash
scripts/checkpoint.sh error <task-id> <error-message>
# Example: scripts/checkpoint.sh error TASK-123456-abc123 "Dependency error"
```

### Task Completion
```bash
scripts/checkpoint.sh complete <task-id> <result>
# Example: scripts/checkpoint.sh complete TASK-123456-abc123 "3 APIs, 10 tests created"
```
**Note**: All instructions must be completed (workflow constraint)

## Implementation Example

```
# Check pending tasks
$ scripts/checkpoint.sh pending
📋 Pending Tasks
(If no tasks, prompt to start new task)

# Task start
$ scripts/checkpoint.sh start "Python function implementation" 4
`🚀 Task started: Python function implementation`
`📝 Task ID: TASK-123456-7f9a2b`
`📊 Estimated steps: 4`

# Instruction usage start (required)
$ scripts/checkpoint.sh instruction-start "instructions/en/presets/cli_tool_basic.md" "CLI tool development" TASK-123456-7f9a2b
`📚 Instruction usage started: cli_tool_basic.md`
`   Purpose: CLI tool development`
`📌 Task ID: TASK-123456-7f9a2b`

# Progress report (only possible while using instruction)
$ scripts/checkpoint.sh progress TASK-123456-7f9a2b 2 4 "Implementation done" "Create tests"
`[2/4] Implementation done | Next: Create tests`
`📌 Task ID: TASK-123456-7f9a2b`

# Instruction usage complete
$ scripts/checkpoint.sh instruction-complete "instructions/en/presets/cli_tool_basic.md" "Basic features implemented" TASK-123456-7f9a2b
`✅ Instruction usage completed: cli_tool_basic.md`
`📊 Result: Basic features implemented`
`📌 Task ID: TASK-123456-7f9a2b`

# Task completion (all instructions must be completed)
$ scripts/checkpoint.sh complete TASK-123456-7f9a2b "1 function, 3 tests"
`✅ Task completed: TASK-123456-7f9a2b`
`📊 Result: 1 function, 3 tests`

# Check task details
$ scripts/checkpoint.sh summary TASK-123456-7f9a2b
(Detailed task history displayed)
```

## Important Notes

1. **Task ID generation**: Auto-generated with timestamp + random value (e.g., TASK-123456-abc123)
2. **Keep it concise**: Status and actions should be short and clear
3. **Maintain consistency**: Use the same task ID and step count for the same task
4. **Path awareness**: `scripts/checkpoint.sh` is a relative path from project root
5. **Workflow constraints**: Progress requires active instruction, completion requires all instructions closed

## Integration with Other Instructions

This checkpoint management is used in combination with all instruction sheets.
Execute `scripts/checkpoint.sh` for each major step in the instructions.

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created**: 2025-06-30
- **Updated**: 2025-07-27