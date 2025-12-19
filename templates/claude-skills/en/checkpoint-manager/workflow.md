# Checkpoint Workflow Details

## Standard Workflow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Conversation Start                                       │
│    └─ Check pending tasks with 'pending'                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Task Start                                               │
│    └─ Register task with 'start' (task ID auto-generated)   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. Instruction Selection                                    │
│    ├─ Record instruction use with 'instruction-start'       │
│    └─ Load instruction and execute work                     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. Progress Reports (repeat)                                │
│    └─ Update status with 'progress' (during instruction)    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. Instruction Complete                                     │
│    └─ Complete instruction with 'instruction-complete'      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. Task Complete                                            │
│    └─ Finish task with 'complete' (all instructions done)   │
└─────────────────────────────────────────────────────────────┘
```

## Command Details

### pending - Check Pending Tasks

```bash
scripts/checkpoint.sh pending
```

**Output example:**
```
📋 Pending Tasks
┌──────────────────────┬────────────────┬─────────┐
│ Task ID              │ Task Name      │ Progress│
├──────────────────────┼────────────────┼─────────┤
│ TASK-123456-abc123   │ API impl       │ 2/5     │
└──────────────────────┴────────────────┴─────────┘
```

### start - Start Task

```bash
scripts/checkpoint.sh start "<task-name>" <steps>
```

**Arguments:**
- `<task-name>`: Brief description of work
- `<steps>`: Expected number of steps

**Output example:**
```
🚀 Task started: API implementation
📝 Task ID: TASK-123456-abc123
📊 Estimated steps: 5
```

### instruction-start - Start Instruction Use

```bash
scripts/checkpoint.sh instruction-start "<path>" "<purpose>" [task-id]
```

**Arguments:**
- `<path>`: Instruction file path
- `<purpose>`: Purpose of use
- `[task-id]`: Task ID (optional but recommended)

**Output example:**
```
📚 Instruction started: web_api_production.md
   Purpose: REST API development
📌 Task ID: TASK-123456-abc123
```

### progress - Report Progress

```bash
scripts/checkpoint.sh progress <task-id> <current> <total> "<status>" "<next>"
```

**Arguments:**
- `<task-id>`: Task ID
- `<current>`: Current step
- `<total>`: Total steps
- `<status>`: Current status
- `<next>`: Next action

**Constraint:** Only allowed during instruction use

**Output example:**
```
[2/5] Design complete | Next: Start implementation
📌 Task ID: TASK-123456-abc123
```

### instruction-complete - Complete Instruction Use

```bash
scripts/checkpoint.sh instruction-complete "<path>" "<result>" [task-id]
```

**Arguments:**
- `<path>`: Instruction file path
- `<result>`: Result/outcome
- `[task-id]`: Task ID

**Output example:**
```
✅ Instruction complete: web_api_production.md
📊 Result: 3 endpoints implemented
📌 Task ID: TASK-123456-abc123
```

### complete - Complete Task

```bash
scripts/checkpoint.sh complete <task-id> "<result>"
```

**Arguments:**
- `<task-id>`: Task ID
- `<result>`: Final result

**Constraint:** All instructions must be completed

**Output example:**
```
✅ Task complete: TASK-123456-abc123
📊 Result: REST API 3 endpoints, 10 tests created
```

### error - Report Error

```bash
scripts/checkpoint.sh error <task-id> "<message>"
```

**Arguments:**
- `<task-id>`: Task ID
- `<message>`: Error description

**Output example:**
```
❌ Error reported: TASK-123456-abc123
   Dependency error: package not found
```

### summary - Show History

```bash
scripts/checkpoint.sh summary <task-id>
```

Shows complete task history (start, progress, instruction use, completion) in chronological order.

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| Progress report failed | No active instruction | Run instruction-start first |
| Task completion failed | Incomplete instructions | Run instruction-complete first |
| Unknown task ID | ID doesn't exist | Check with pending |

## Log Files

Checkpoint logs are saved in:

```
.ai_checkpoints/
├── tasks/
│   └── TASK-123456-abc123.json
└── instructions/
    └── usage.log
```
