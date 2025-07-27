---
description: "Execute commit, push, and issue report in batch"
---

# Batch Commit and Report

Execute commit, push, and issue report operations in a single command. This custom command automates the Git workflow for the AI instruction kit repository.

## Usage

```
/commit-and-report <commit-message> [issue-number]
```

## Execution Details

1. **Git operations**
   - Add all changes: `git add -A`
   - Commit with the provided message
   - Push to remote repository

2. **Issue reporting** (if issue number provided)
   - Add a comment to the specified GitHub issue
   - Include commit hash and summary

3. **Error handling**
   - Rollback on failure
   - Display detailed error messages

## Examples

```
/commit-and-report "feat: Add new instruction module"
/commit-and-report "fix: Correct typo in README" 42
```

## Notes

- Requires Git configuration and GitHub authentication
- Automatically detects the current branch
- Uses the project's commit message conventions