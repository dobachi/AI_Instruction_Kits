# Skill Orchestrator

Leverages installed skills to streamline work based on the task at hand.

## Instructions

1. Check installed skills in `.claude/skills/` and use them according to the task
2. If skills are missing, guide to dobachi/claude-skills-marketplace
3. If custom skills are needed, guide to the skill-creator skill

## Installed Skills

| Skill | Purpose | Auto-Suggestion |
|-------|---------|-----------------|
| commit-safe | Safe commits | Suggests file-specific commit after changes |

> Use your AI tool's native features for task management, progress tracking, Git worktrees, and builds.

## Basic Workflow

```
1. Work → 2. Track progress with native task management → 3. Commit safely with commit-safe
```

## If Skills Are Missing

Install additional skills from the marketplace:
https://github.com/dobachi/claude-skills-marketplace

## Checking for Updates / Migrations

1. Run `bash instructions/ai_instruction_kits/scripts/run-migrations.sh --dry-run` to check for pending migrations
2. If any are pending, run `run-migrations.sh`, then install the latest structure with `setup-project.sh --skip-instructions`
3. See `docs/UPGRADING.md` for details. Never commit `*.backup.*`

---
## License Information
- **License**: Apache-2.0
- **Original Author**: dobachi
- **Created Date**: 2025-06-30
- **Updated Date**: 2026-03-14
