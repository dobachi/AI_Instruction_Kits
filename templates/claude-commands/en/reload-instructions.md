---
description: "Update and reload AI instruction system to the latest version"
---

# Reload Instructions

Update the AI instruction system to the latest version and reload all instructions.

## Usage

```
/reload-instructions
```

## Execution Details

1. **Git update**
   - Pull latest changes from remote repository
   - Merge with local changes if necessary

2. **Instruction reload**
   - Clear instruction cache
   - Re-read ROOT_INSTRUCTION.md
   - Re-read CHECKPOINT_MANAGER.md

3. **Validation**
   - Check for conflicts
   - Verify instruction integrity
   - Display update summary

## Examples

```
/reload-instructions
```

## Notes

- Preserves local uncommitted changes
- Automatically resolves simple conflicts
- Reports any manual intervention needed