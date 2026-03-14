# Skill Orchestrator

Leverages installed skills to streamline work based on the task at hand.

## Instructions

1. Check installed skills in `.claude/skills/` and use them according to the task
2. If skills are missing, guide to dobachi/claude-skills-marketplace
3. If custom skills are needed, guide to the skill-creator skill

## Installed Skills

| Skill | Purpose | Auto-Suggestion |
|-------|---------|-----------------|
| checkpoint-manager | Task progress tracking | Suggests pending check at conversation start |
| worktree-manager | Git worktree management | Suggests worktree creation for complex tasks |
| auto-build | Project build automation | Suggests build after code changes |
| commit-safe | Safe commits | Suggests file-specific commit after changes |

## Basic Workflow

```
1. Check pending → 2. Start task → 3. Create worktree (optional) → 4. Work → 5. Commit → 6. Complete
```

## If Skills Are Missing

Install additional skills from the marketplace:
https://github.com/dobachi/claude-skills-marketplace

---
## License Information
- **License**: Apache-2.0
- **Original Author**: dobachi
- **Created Date**: 2025-06-30
- **Updated Date**: 2026-03-14
