# Upgrade Guide (for projects using AI Instruction Kits)

Steps and per-version migration log for projects that use this kit **as a submodule** (template-derived or direct).

## Version reconciliation

- The kit's current version lives in the `VERSION` file (single source of truth).
- Each consuming project records its applied version in `instructions/.ai_ik_applied_version`.
- `scripts/run-migrations.sh` reconciles the two and applies only the pending `migrations/<version>.sh` in semver order (each migration is idempotent and takes backups).
- The SessionStart hook (`submodule-update-check.sh`) reconciles at pull/session start and surfaces the steps to the AI when migrations are pending.

```bash
# Preview pending migrations
bash instructions/ai_instruction_kits/scripts/run-migrations.sh --dry-run

# Apply pending migrations and record the applied version
bash instructions/ai_instruction_kits/scripts/run-migrations.sh
```

## Standard procedure for AI agents

When pending migrations or legacy structures are detected, run the following in order.

```bash
# 1. Apply per-version migrations (cleanup etc., with backups)
bash instructions/ai_instruction_kits/scripts/run-migrations.sh

# 2. Install the latest structure (never overwrites PROJECT.md)
bash instructions/ai_instruction_kits/scripts/setup-project.sh --auto --skip-instructions --submodule
```

Notes:

- Never commit `*.backup.*` files (backups created by migrate / setup).
- `instructions/PROJECT.md` holds project-specific config. **Never overwrite it** (always use `--skip-instructions`).
- Review changes, then commit with commit-safe or `scripts/commit.sh`.

## Per-version migration log

When adding a new version, append the range and steps here and provide a matching idempotent `migrations/<version>.sh`.

### → 2.2.0 (all skills consolidated into the external marketplace)

| Type | Detail |
|------|--------|
| Removed | In-repo plugin marketplace (`.claude-plugin/`) |
| Removed | Per-CLI local skill distribution (`.claude/skills/`, `.agents/skills/`, `.codex/prompts/`, `.gemini/commands/`, `scripts/gemini/`) |
| Consolidated | All skills, including commit-safe, into the external marketplace [dobachi/claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace) |

Migration script: `migrations/2.2.0.sh` (backs up and removes the kit-distributed skill copies; leaves user-authored skills untouched).

`setup-project.sh` no longer distributes skills — it prints install instructions at the end. Because Codex, Gemini, and Antigravity share the Agent Skills standard (`~/.agents/skills`), running the marketplace `install.sh` once covers every CLI. The instruction files (`CLAUDE.md`, `CODEX.md`, `GEMINI.md`, `AGENTS.md`) are still set up by `setup-project.sh`.

Install:

```bash
git clone https://github.com/dobachi/claude-skills-marketplace
bash claude-skills-marketplace/install.sh
```

### → 2.1.0 (Antigravity CLI support / core skill consolidation)

| Type | Detail |
|------|--------|
| Removed | Skills checkpoint-manager / worktree-manager / auto-build; commands checkpoint / build |
| Migrated | Legacy flat `.claude/skills/*.md` → `<name>/SKILL.md` format |
| Added | Antigravity CLI support (`AGENTS.md`, `.agents/skills/`) — consolidated into the external marketplace in 2.2.0 |
| Added | Plugin marketplace (`.claude-plugin/`, optional) — removed in 2.2.0 |

Migration script: `migrations/2.1.0.sh` (delegates cleanup to `migrate-skills.sh`).

## Plugin usage

Install skills, including commit-safe, from the external marketplace:

```text
/plugin marketplace add dobachi/claude-skills-marketplace
/plugin install commit-safe@dobachi-skills
```
