---
name: commit-safe
description: Skill for safe commits. Reviews changes before selective commits. Proposes file-specific commits for large changes, prevents use of git add -A.
---

# Safe Commit Skill

A skill for reviewing changes and performing selective commits.

## Auto-Suggestion Triggers

| Situation | Suggestion |
|-----------|------------|
| After code changes | "Shall I commit the changes?" |
| Multiple file changes | "Shall I commit specific files?" |
| git add -A usage | "Recommend specifying files for commit" |

## Procedure

### 1. Review Changes

```bash
git status --short
git diff --stat
```

### 2. File-Specific Commit

```bash
# Stage specific files
git add [specified files...]

# Commit with message
bash scripts/commit.sh "commit message"
```

### 3. Commit Message Convention

```
<type>: <description>

- feat: New feature
- fix: Bug fix
- docs: Documentation update
- refactor: Refactoring
- test: Test additions/modifications
```

## Examples

```bash
# Commit specific files only
git add src/main.py src/utils.py
bash scripts/commit.sh "feat: Add new feature"

# Commit documentation only
git add README.md docs/guide.md
bash scripts/commit.sh "docs: Update README"
```

## Recommended Workflow

1. Check changes with `git status`
2. Group related changes together
3. Commit with specific files
4. Split large changes into multiple small commits

## Notes

- Avoid using `git add -A` or `git add .`
- Use `scripts/commit.sh` for commits (prevents AI signatures)
- Never commit sensitive files (.env, credentials, etc.)
- Always review with `git diff --staged` before committing
