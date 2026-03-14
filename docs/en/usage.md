---
layout: default
title: AI Instruction Kits
description: Usage Guide - Detailed usage and best practices
lang: en
---

# Usage Guide

Learn how to use AI Instruction Kits v2.0 with its skill-based architecture and best practices.

## 📖 Basic Usage

In v2.0, simply referencing CLAUDE.md is all you need. ROOT_INSTRUCTION automatically selects the optimal skill for your task. After setup, the workflow is extremely simple.

### Setup

```bash
# Integrate into your project
bash scripts/setup-project.sh
```

### Daily Usage

```bash
# That's all you need! ROOT_INSTRUCTION auto-selects the right skill
claude "Refer to CLAUDE.md and implement user authentication"

# Same entry point regardless of task type
claude "Refer to CLAUDE.md and investigate performance bottlenecks"
claude "Refer to CLAUDE.md and design a RESTful API"
```

**How it works**: `CLAUDE.md` → `ROOT_INSTRUCTION.md` (Skill Orchestrator) → auto-selects optimal skill from `.claude/skills/` → executes task

## 🎯 Skill-Based Workflow

The core of v2.0 is four core skills placed in `.claude/skills/`. ROOT_INSTRUCTION automatically suggests the appropriate skill based on the task at hand.

### checkpoint-manager (Task Progress Management)

Automatically suggests checking pending tasks at the start of a conversation.

```bash
# Start a task
scripts/checkpoint.sh start "New feature development" 5
# → Task ID: TASK-123456-abc is issued

# Report progress
scripts/checkpoint.sh progress TASK-123456-abc 2 5 "Design complete" "Start implementation"

# Complete task
scripts/checkpoint.sh complete TASK-123456-abc "5 features implemented, 20 tests created"
```

**Auto-suggestion timing**: Suggests checking pending tasks at conversation start

### worktree-manager (Git Worktree Management)

Suggests creating a worktree for complex tasks or multi-file changes.

```bash
# Create worktree
scripts/worktree-manager.sh create TASK-123456-abc "feature-auth"
# → .gitworktrees/ai-TASK-123456-abc-feature-auth/ is created

# Move to working directory
cd .gitworktrees/ai-TASK-123456-abc-feature-auth/

# After completing work
scripts/worktree-manager.sh complete TASK-123456-abc
```

**Auto-suggestion timing**: Suggests worktree creation for complex tasks

### auto-build (Automatic Build & Test)

Automatically detects project type and runs the appropriate build command.

```bash
# Auto-detects project type and builds
# package.json → npm run build
# Cargo.toml → cargo build
# go.mod → go build
# etc.
```

**Auto-suggestion timing**: Suggests build/test execution after code changes

### commit-safe (Safe Commits)

Creates clean commits without AI signatures.

```bash
# Clean commit with AI signatures automatically removed
scripts/commit.sh "feat: Add user authentication"
```

**Auto-suggestion timing**: Suggests file-specific commits after changes

### Basic Workflow

```
1. Check pending → 2. Start task → 3. Create worktree (optional) → 4. Work → 5. Commit → 6. Complete
```

## 🛒 Marketplace Skills

Install additional community-built skills from [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace).

### Installation

```bash
# Download skills from the marketplace
# Simply place them in .claude/skills/

# Example: Add a code review skill
cp path/to/code-review .claude/skills/code-review

# After installation, ROOT_INSTRUCTION automatically recognizes new skills
```

### Creating Custom Skills

If you need custom skills, you can use the skill-creator skill. Simply place skill files in `.claude/skills/` to make them available.

## 📊 Checkpoint Management

`scripts/checkpoint.sh` is a script that records and manages task progress in detail.

### Key Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `start` | Start a new task | `scripts/checkpoint.sh start "API development" 5` |
| `progress` | Report progress | `scripts/checkpoint.sh progress TASK-xxx 2 5 "Design complete" "Start implementation"` |
| `complete` | Complete a task | `scripts/checkpoint.sh complete TASK-xxx "3 endpoints implemented"` |
| `pending` | List pending tasks | `scripts/checkpoint.sh pending` |
| `summary` | Show task details | `scripts/checkpoint.sh summary TASK-xxx` |
| `error` | Report an error | `scripts/checkpoint.sh error TASK-xxx "Dependency error"` |

### Tracking Skill Usage

```bash
# Record skill usage start
scripts/checkpoint.sh instruction-start ".claude/skills/auto-build" "API development" TASK-xxx

# Record skill usage completion
scripts/checkpoint.sh instruction-complete ".claude/skills/auto-build" "3 endpoints implemented" TASK-xxx
```

### Visualizing Progress

```bash
# Check pending tasks
scripts/checkpoint.sh pending

# View detailed task history
scripts/checkpoint.sh summary TASK-xxx

# Show help
scripts/checkpoint.sh help
```

## 🌲 Git Worktree Workflow

For complex tasks or changes spanning multiple files, working in a Git worktree is recommended.

### Recommended Flow

```bash
# 1. Start task
scripts/checkpoint.sh start "Auth feature development" 5
# → TASK-123456-abc

# 2. Create worktree
scripts/worktree-manager.sh create TASK-123456-abc "feature-auth"

# 3. Move to worktree and work
cd .gitworktrees/ai-TASK-123456-abc-feature-auth/

# 4. Work and commit
scripts/commit.sh "feat: Add authentication feature"

# 5. Complete task and clean up worktree
scripts/checkpoint.sh complete TASK-123456-abc "Auth feature implemented"
scripts/worktree-manager.sh complete TASK-123456-abc
```

### Worktree Management Commands

```bash
# List worktrees
scripts/worktree-manager.sh list

# Switch to a specific worktree
scripts/worktree-manager.sh switch TASK-xxx

# Complete and clean up
scripts/worktree-manager.sh complete TASK-xxx

# Bulk remove unused worktrees
scripts/worktree-manager.sh clean
```

## ⚙️ Customizing PROJECT.md

Centralize project-specific settings in PROJECT.md.

### Basic Configuration Example

```markdown
## Project-Specific Instructions

### Coding Standards
- ESLint config: Follow .eslintrc.js
- Naming convention: camelCase
- Comments: JSDoc format

### Test Requirements
- Coverage: 80% minimum
- E2E tests: Using Cypress

### Build Settings
- Build command: npm run build
- Lint command: npm run lint
- Test command: npm run test

### Instruction Priority
1. PROJECT.md (highest priority)
2. Task-specific instructions
3. Skill auto-selection
```

## 🤖 Codex CLI / Gemini CLI

AI Instruction Kits supports AI CLI tools beyond Claude Code.

### Codex CLI

Custom prompts are placed in `.codex/prompts/`. The filename becomes the `/command-name` you can invoke.

```bash
# Available commands
/build              # Detect project type and assist with build
/checkpoint         # Guide through checkpoint.sh subcommands
/commit-safe        # Safe commits without AI signatures
/commit-and-report  # Commit, push, and report to Issues
/reload-instructions # Reload instructions
```

### Gemini CLI

TOML command definitions are placed in `.gemini/commands/`. The same command set as Codex CLI is available.

## 🎯 Best Practices

### 1. Skill Selection Tips
- Let ROOT_INSTRUCTION handle it by default (auto-selection is optimal)
- Reference `.claude/skills/` files directly when you need a specific skill
- Search the marketplace for missing skills

### 2. Managing Customizations
- Centralize project-specific settings in PROJECT.md
- Track changes with version control
- Share with team members

### 3. Feedback Loop
- Accumulate work history with the checkpoint feature
- Evaluate skill effectiveness and customize as needed
- Consider creating new skills or contributing to the marketplace

## 🔍 Troubleshooting

### Q: Skills are not being auto-selected?

A: Verify that skill files are placed in the `.claude/skills/` directory.

```bash
# Check for installed skills
ls .claude/skills/

# Re-run setup
bash scripts/setup-project.sh
```

### Q: Checkpoint log not found?

A: `checkpoint.log` is created in the project root. It is auto-generated when you start your first task.

```bash
# Start a new task to create the log
scripts/checkpoint.sh start "Test task" 1
```

### Q: Worktree creation fails?

A: Make sure you are running from the Git repository root directory.

```bash
# Navigate to repository root
cd $(git rev-parse --show-toplevel)

# Create worktree
scripts/worktree-manager.sh create TASK-xxx "description"
```

### Q: Unsure about instruction priority?

A: Instructions are applied in the following priority order:

```
1. PROJECT.md (highest priority)
2. Task-specific instructions
3. ROOT_INSTRUCTION skill selection
4. Skill default behavior
```

## 📚 Learn More

- [Features](features) - Detailed feature explanations
- [Quick Start](quickstart) - Get started in 5 minutes
- [GitHub](https://github.com/dobachi/AI_Instruction_Kits) - Source code
- [Skills Marketplace](https://github.com/dobachi/claude-skills-marketplace) - Community-built skills

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>💡 Tip</h3>
  <p>In v2.0, simply saying "Refer to CLAUDE.md" is enough for ROOT_INSTRUCTION to auto-select the optimal skill. Start simple, then add skills from the marketplace as needed.</p>
</div>
