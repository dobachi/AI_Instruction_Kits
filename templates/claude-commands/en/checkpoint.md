---
description: "Execute AI instruction system checkpoint"
---

# Checkpoint Execution

Execute the AI instruction system checkpoint script to manage task progress.

## Usage

```
/checkpoint [start <task-id> <task-name> <steps>]
```

## Execution Details

1. **Basic checkpoint execution**
   ```bash
   !bash scripts/checkpoint.sh $ARGUMENTS
   ```

2. **Result display**
   - Current task status
   - Progress status
   - Next action suggestions

## Examples

```
/checkpoint
/checkpoint start task-123 "new feature implementation" 5
```