---
description: "Safely review and commit changes"
---

# Safe Commit

Review changes before committing and selectively stage files.

## Usage

```
/commit-safe "commit message" [file paths...]
```

## Execution Details

1. **Review changes**
   ```bash
   !git status --short
   !git diff --stat
   ```

2. **Stage and commit specified files only**
   ```bash
   # If files are specified
   !git add [specified files]
   !git commit -m "commit message"
   
   # If no files specified
   !echo "⚠️ Please specify files to commit. Use /commit-and-report for staging all changes."
   ```

## Examples

```
/commit-safe "feat: Add new feature" src/main.py src/utils.py
/commit-safe "docs: Update README" README.md
```

## Recommended Workflow

1. First check changes with `git status`
2. Commit only necessary files
3. Split large changes into smaller, focused commits

## Related Commands

- `/commit-and-report` - Commit all changes at once (use with caution)
- `git status` - Check current changes
- `git diff` - View detailed changes