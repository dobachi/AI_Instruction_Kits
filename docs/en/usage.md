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

The core of v2.0 is the **commit-safe** skill, installed from the marketplace (`/plugin install commit-safe@dobachi-skills`). Once installed, ROOT_INSTRUCTION automatically suggests the appropriate skill based on the task at hand.

For task management (Todo), progress tracking, Git worktree, and build detection, use your AI tool's native features (Claude Code's Todo, worktree, build detection), since modern AI agents ship with these built in. No custom scripts are required.

### commit-safe (Safe Commits)

Creates clean commits without AI signatures.

```bash
# Clean commit with AI signatures automatically removed
scripts/commit.sh "feat: Add user authentication"
```

**Auto-suggestion timing**: Suggests file-specific commits after changes

### Task Management, Worktree, and Build Use Your AI Tool's Native Features

For progress tracking and build automation, use your AI tool's native features (Claude Code's Todo, worktree, build detection).

### Basic Workflow

```
1. Ask the AI for a task → 2. AI manages progress and works via native features → 3. Commit with commit-safe
```

## 🛒 Marketplace Skills

Install additional skills from [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace).

### Install via Claude Code `/plugin` Command

```bash
# Step 1: Register the marketplace (one-time only)
/plugin marketplace add dobachi/claude-skills-marketplace

# Step 2: Install skills
/plugin install code-reviewer@dobachi-skills
/plugin install data-analyst@dobachi-skills
```

Run `/plugin` alone to open the plugin manager UI for interactive skill browsing, installation, and management.

### Installation Scopes

| Scope | Description | Saved to |
|-------|-------------|----------|
| **User** | Available across all your projects | `~/.claude/settings.json` |
| **Project** | Available to team members | `.claude/settings.json` |
| **Local** | Only you, this repo only | `.claude/settings.local.json` |

### Manual Installation

If not using the `/plugin` command, you can place skill files directly:

```bash
# Copy a skill directory from the marketplace
cp -r path/to/code-reviewer .claude/skills/code-reviewer
```

### Creating Custom Skills

If you need custom skills, use the skill-creator skill from the marketplace. Simply place skill files in `.claude/skills/` to make them available.

## 📊 Task Management & Progress Tracking

For task management (Todo) and progress tracking, use your AI tool's native features. Claude Code's Todo, for example, automatically breaks down tasks and visualizes progress during the conversation. A custom checkpoint script is no longer needed.

## 🌲 Git Worktree Workflow

For complex tasks or changes spanning multiple files, working in a Git worktree is recommended. For creating, switching, and cleaning up worktrees, use your AI tool's native features (Claude Code's worktree, for example).

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

## 🤖 Codex CLI / Gemini CLI / Antigravity CLI

AI Instruction Kits supports AI CLI tools beyond Claude Code. Each tool has its own instruction file (`CODEX.md` / `GEMINI.md` / `AGENTS.md`, all symlinks to `PROJECT_META.md`).

**All skills are consolidated in the external marketplace.** Since Codex, Gemini, and Antigravity share the Agent Skills standard (`~/.agents/skills/<name>/SKILL.md`), running the marketplace `install.sh` once makes skills such as commit-safe available across every CLI.

```bash
git clone https://github.com/dobachi/claude-skills-marketplace
bash claude-skills-marketplace/install.sh
```

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
- Track work history with your AI tool's native progress features
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

### Q: How do I manage task progress?

A: Use your AI tool's native features (Claude Code's Todo, for example). Task breakdown and progress visualization happen automatically during the conversation.

### Q: I want to use a worktree?

A: Use your AI tool's native worktree feature. Operating from the repository root directory is recommended.

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
