---
name: worktree-manager
description: Skill for creating and managing Git worktrees. Proposes worktree creation for complex tasks or multi-file changes, guides merge and cleanup on task completion. Integrates with checkpoint-manager.
---

# Worktree Manager Skill

A skill that provides isolated working environments per task using Git worktrees.

## Auto-Suggestion Triggers

| Situation | Suggestion |
|-----------|------------|
| Multi-file change task start | "Shall I create a worktree?" |
| After checkpoint start | "Shall I create a worktree for this task?" |
| Task completion | "Shall I merge and clean up the worktree?" |
| Orphaned worktree detected | "Shall I clean up unused worktrees?" |

## Workflow Overview

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  create     │    │  work       │    │  complete   │    │  clean      │
│  worktree   │ → │  (inside    │ → │  merge &    │ → │  cleanup    │
│             │    │   worktree) │    │  remove     │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

## Command Reference

```bash
# Create a new worktree
scripts/worktree-manager.sh create <task-id> <description>

# List active worktrees
scripts/worktree-manager.sh list

# Show worktree path (for switching)
scripts/worktree-manager.sh switch <task-id>

# Complete worktree (merge/remove options)
scripts/worktree-manager.sh complete <task-id>

# Clean up orphaned worktrees
scripts/worktree-manager.sh clean
```

## Usage Scenarios

### Scenario 1: Create Worktree for New Task

After starting a checkpoint, create a worktree for isolated work:

```
AI: Shall I create a worktree?
    Task: [task name]
    Task ID: TASK-123456-abc123

# Execute
scripts/worktree-manager.sh create TASK-123456-abc123 "feature-dev"
cd .gitworktrees/ai-TASK-123456-abc123-feature-dev/
```

### Scenario 2: List Active Worktrees

```
AI: Shall I check active worktrees?

# Execute
scripts/worktree-manager.sh list
```

### Scenario 3: Complete Task Worktree

```
AI: Shall I merge and clean up the worktree?

# Execute
scripts/worktree-manager.sh complete TASK-123456-abc123
# Options: 1) Merge and delete 2) Keep 3) Delete without merge
```

### Scenario 4: Cleanup

```
AI: Shall I clean up orphaned worktrees?

# Execute
scripts/worktree-manager.sh clean
```

## Integration with checkpoint-manager

Recommended workflow:

```bash
# 1. Start task
scripts/checkpoint.sh start "Feature development" 3
# → TASK-123456-abc123

# 2. Create worktree
scripts/worktree-manager.sh create TASK-123456-abc123 "feature-dev"
cd .gitworktrees/ai-TASK-123456-abc123-feature-dev/

# 3. Do work...

# 4. Complete task
scripts/checkpoint.sh complete TASK-123456-abc123 "Done"

# 5. Merge and remove worktree
scripts/worktree-manager.sh complete TASK-123456-abc123
```

## Decision Criteria

### When to Suggest Worktree Creation

- Changes expected across multiple files
- Refactoring or large feature additions
- Changes that may affect existing code
- A checkpoint has been started

### When NOT to Suggest Worktree

- Single file minor fixes
- Documentation-only updates
- Configuration file changes only

## Notes

- Worktrees are created in `.gitworktrees/` directory
- Branch names follow `ai-<task-id>-<description>` format
- Run `scripts/worktree-manager.sh` from project root
- `scripts/checkpoint.sh` works inside worktrees too
