# Git Worktree Management System

## Recommended Rule
**Create a dedicated worktree for complex tasks or changes involving multiple files**

### When to use worktree
- Adding/changing multiple files
- Implementing new features
- Refactoring
- Experimental changes

### When worktree is not needed
- Simple fixes to single files
- Typo corrections in documentation
- Minor configuration adjustments

```bash
# 1. Start task (get task ID)
scripts/checkpoint.sh start "Task name" 5
# → Task ID: TASK-123456-abc

# 2. Create worktree (required)
scripts/worktree-manager.sh create TASK-123456-abc "brief-description"
# → .gitworktrees/ai-TASK-123456-abc-brief-description/

# 3. Move and work
cd .gitworktrees/ai-TASK-123456-abc-brief-description/
```

## Basic Commands

```bash
# Create
scripts/worktree-manager.sh create <task-id> <description>

# List
scripts/worktree-manager.sh list

# Complete (choose merge/keep/delete)
scripts/worktree-manager.sh complete <task-id>
```

## Important Notes
- Worktrees are isolated in `.gitworktrees/` (gitignored)
- Avoid direct edits in main directory
- Parallel work on multiple tasks is possible

---
## License Information
- **License**: Apache-2.0
- **Reference**: 
- **Original Author**: dobachi
- **Created**: 2025-01-08
- **Updated**: 2025-01-08