---
description: "Execute AI instruction system checkpoint"
---

# Checkpoint Execution

Execute the AI instruction system checkpoint script to manage task progress.

## Usage

```
/checkpoint <command> [arguments]
```

## Available Commands

### Task Management
- `start <name> <steps>` - Start a new task (Task ID is auto-generated)
- `progress <task-id> <current> <total> <status> <next>` - Report progress (Requires: instruction in use)
- `complete <task-id> <result>` - Complete task (Requires: all instructions completed)
- `error <task-id> <message>` - Report error

### Instruction Management
- `instruction-start <path> <purpose> [task-id]` - Start using instruction
- `instruction-complete <path> <result> [task-id]` - Complete instruction usage

### Status Check
- `pending` - List pending tasks
- `summary <task-id>` - Show task details
- `help` - Show help message

## Execution Details

1. **Checkpoint command execution**
   ```bash
   !bash scripts/checkpoint.sh $ARGUMENTS
   ```

2. **Result display**
   - Command execution results
   - Error messages (if applicable)
   - Next action suggestions

## Examples

```
/checkpoint pending
/checkpoint start "new feature implementation" 5
/checkpoint progress TASK-123456-abc123 2 5 "design complete" "start implementation"
/checkpoint instruction-start "instructions/en/presets/web_api_production.md" "REST API development" TASK-123456-abc123
/checkpoint complete TASK-123456-abc123 "3 API endpoints implemented"
```

## Notes

- Execution without arguments defaults to the `pending` command
- Task IDs are auto-generated when using the `start` command
- The `progress` command can only be executed while using an instruction
- Due to workflow constraints, system instructions are not recommended