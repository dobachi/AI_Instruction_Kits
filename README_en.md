# AI Instruction Kits v2.0 — Skill-Based Architecture

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills Marketplace](https://img.shields.io/badge/Skills-Marketplace-green)](https://github.com/dobachi/claude-skills-marketplace)

English | [Japanese](README.md) | [Project Website](https://dobachi.github.io/AI_Instruction_Kits/)

A lightweight framework for integrating AI instruction systems into your projects. v2.0 replaces the former modular instruction synthesis system with a **skill-based architecture** — simpler, faster, and extensible through the [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace).

## What Changed in v2.0

| Before (v1) | After (v2.0) |
|---|---|
| MODULE_COMPOSER + composer.py + 271 modular files | core skill: commit-safe (others via marketplace) |
| 5-6 hop instruction synthesis pipeline | ~30-line skill orchestrator (ROOT_INSTRUCTION) |
| Python dependency for preset generation | Pure shell — no Python required |
| `.claude/commands/` with 8 command files | `.claude/skills/` with focused skill definitions |
| Presets generated from module combinations | Skills installed directly from marketplace |

The `modular/` directory and legacy components have been archived to the `archive/v1-modular` branch.

## Quick Start

### One-liner Installation

```bash
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash
```

### Interactive Mode

```bash
# Download then run (recommended)
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh -o install.sh
bash install.sh
rm install.sh
```

See the [Quick Start Guide](docs/QUICKSTART.md) for more details.

## Architecture Overview

```
CLAUDE.md
  -> ROOT_INSTRUCTION (~30-line skill orchestrator)
       -> .claude/skills/ (installed skills)
       -> dobachi/claude-skills-marketplace (discover & install more)
```

ROOT_INSTRUCTION acts as a skill orchestrator: it discovers installed skills in `.claude/skills/`, delegates tasks to matching skills, and points users to the marketplace when a needed skill is missing.

For task management, progress tracking, Git worktree, and build detection, use your AI tool's native features (Claude Code's Todo, worktree, build detection).

## Core Skill

This skill ships with AI Instruction Kits and is installed by `setup-project.sh`:

| Skill | Purpose | Auto-suggestion |
|-------|---------|-----------------|
| **commit-safe** | Safe file-specific commits | Suggests commit after changes |

Install additional skills from the [marketplace](https://github.com/dobachi/claude-skills-marketplace).

## Additional Skills (Marketplace)

Browse and install additional skills from the marketplace:

**https://github.com/dobachi/claude-skills-marketplace**

Example marketplace skills include role-based skills (web-api-dev, data-analyst, technical-writer, etc.), utility skills (fact-checker, code-reviewer, etc.), and more.

```bash
# Install via Claude Code's /plugin command
/plugin marketplace add dobachi/claude-skills-marketplace
/plugin install code-reviewer@dobachi-skills
```

## Directory Structure

```
.
├── docs/              # Human-readable documentation
│   └── examples/      # Usage examples
│       ├── ja/        # Japanese examples
│       └── en/        # English examples
├── instructions/      # AI instruction sheets
│   ├── ja/            # Japanese instructions
│   │   ├── system/    # System instructions (ROOT_INSTRUCTION, etc.)
│   │   ├── general/   # General instructions
│   │   ├── coding/    # Coding instructions
│   │   ├── writing/   # Writing instructions
│   │   ├── analysis/  # Analysis instructions
│   │   ├── creative/  # Creative instructions
│   │   └── agent/     # Agent-type instructions
│   └── en/            # English instructions (same structure)
├── templates/         # Templates
│   ├── ja/            # Japanese templates
│   │   ├── instruction_template.md
│   │   └── PROJECT_TEMPLATE.md
│   ├── en/            # English templates
│   │   ├── instruction_template.md
│   │   └── PROJECT_TEMPLATE.md
│   ├── claude-skills/ # Core skill templates
│   └── git-hooks/     # Git hook templates
├── downstream/        # Clones of projects using this as submodule (.gitignored)
├── scripts/           # Tools and utilities
│   ├── setup-project.sh    # Project integration setup
│   ├── install.sh          # One-liner installer
│   ├── uninstall.sh        # Uninstaller
│   ├── commit.sh           # Clean commit (no AI signature)
│   └── lib/
│       └── i18n.sh         # Internationalization library
├── .claude/           # Claude Code configuration
│   ├── settings.json  # Hook and attribution settings
│   └── skills/        # Core skill (commit-safe)
├── .claude-plugin/    # Plugin marketplace definition (installable via /plugin)
│   ├── marketplace.json
│   └── plugin.json
└── .agents/           # Antigravity CLI skills (used with AGENTS.md)
    └── skills/        # <name>/SKILL.md (Agent Skills standard)
```

## Key Files

### AI Instructions
- **[instructions/en/system/ROOT_INSTRUCTION.md](instructions/en/system/ROOT_INSTRUCTION.md)** — Skill orchestrator (~30 lines)
- **[instructions/en/system/CLAUDE_CODE_AGENT.md](instructions/en/system/CLAUDE_CODE_AGENT.md)** — Agent feature guide

### Documentation
- **[Project Site](https://dobachi.github.io/AI_Instruction_Kits/en/)** — Detailed documentation (GitHub Pages)
  - [Quick Start](https://dobachi.github.io/AI_Instruction_Kits/en/quickstart)
  - [Usage Guide](https://dobachi.github.io/AI_Instruction_Kits/en/usage)
  - [Features](https://dobachi.github.io/AI_Instruction_Kits/en/features)

## Installation

### Project Integration (Recommended)

```bash
# Run in your project's root directory
bash path/to/AI_Instruction_Kits/scripts/setup-project.sh
```

#### Integration Modes

```bash
# Interactive selection (default)
bash scripts/setup-project.sh

# Direct mode specification
bash scripts/setup-project.sh --copy      # Copy mode
bash scripts/setup-project.sh --clone     # Clone mode
bash scripts/setup-project.sh --submodule # Submodule mode (recommended)
```

| Mode | Description | Benefits | Update Method |
|------|-------------|----------|---------------|
| **copy** | Direct file copy | No Git required, simplest, works offline | Manual re-run |
| **clone** | Independent Git repository | Freely modifiable, preserves history | `git pull` |
| **submodule** | Git submodule (recommended) | Version pinning, parent repo integration | `git submodule update --remote` |

#### Setup Options

```bash
# Auto mode: Only confirm PROJECT.md, auto-install everything else
bash scripts/setup-project.sh --auto --submodule

# Force mode: No confirmations (for CI/CD)
bash scripts/setup-project.sh --submodule --force

# Dry-run mode: Preview changes without applying
bash scripts/setup-project.sh --dry-run

# Show help
bash scripts/setup-project.sh --help
```

#### What setup-project.sh Does

1. Integrates the repository (copy/clone/submodule)
2. Creates `instructions/PROJECT.md` and `PROJECT.en.md`
3. Links `CLAUDE.md`, `GEMINI.md`, `CURSOR.md` to project instructions
4. Installs the core skill (commit-safe) into `.claude/skills/`
5. Sets up Git hooks (AI signature prevention)
6. Displays marketplace URL for additional skills

Result:

```
your-project/
├── .claude/
│   └── skills/
│       └── commit-safe/
├── instructions/
│   ├── ai_instruction_kits/  # Submodule (this repository)
│   ├── PROJECT.md            # Project-specific settings (Japanese)
│   └── PROJECT.en.md         # Project-specific settings (English)
├── CLAUDE.md -> instructions/PROJECT.en.md
├── GEMINI.md -> instructions/PROJECT.en.md
└── CURSOR.md -> instructions/PROJECT.en.md
```

#### Using Custom Repositories

```bash
# Use a forked repository
bash scripts/setup-project.sh --url https://github.com/yourname/AI_Instruction_Kits.git --clone

# Use a private repository
bash scripts/setup-project.sh --url git@github.com:company/private-instructions.git --submodule
```

### Basic Usage

```bash
# AI instructions are simple
claude "Please refer to CLAUDE.md and implement user authentication"
```

ROOT_INSTRUCTION automatically discovers installed skills and applies them to the task at hand.

## Uninstallation

```bash
# Normal uninstall (with confirmation)
bash scripts/uninstall.sh

# Force uninstall (no confirmation)
bash scripts/uninstall.sh --force

# Dry-run (check what would be removed)
bash scripts/uninstall.sh --dry-run

# Remote execution
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/uninstall.sh | bash -s -- --force
```

### Items Removed
- `instructions/ai_instruction_kits/` (submodule/clone/copy)
- Symbolic links in `scripts/` directory
- Configuration files (`CLAUDE.md`, `GEMINI.md`, `CURSOR.md`)
- `.claude/skills/` (installed skills)
- `.git/hooks/prepare-commit-msg`
- Backup files (optional)

### Items Kept
- `instructions/PROJECT.md` (project-specific configuration)

For details, run `bash scripts/uninstall.sh --help`.

## Antigravity CLI Skills

For Antigravity CLI (`agy`) users, the kit provides a root `AGENTS.md` (instructions) and `.agents/skills/<name>/SKILL.md` (skills / slash commands). `AGENTS.md` is a cross-tool standard also read by Codex, and `.agents/skills/` uses the same Agent Skills standard as Claude Code.

These are configured automatically when running `setup-project.sh`. Run `agy inspect` to verify what is loaded.

## Migrating from older versions

Projects that used an older version of this kit may still contain deprecated skills (checkpoint-manager / worktree-manager / auto-build) or legacy-format skills. Migrate safely (backup, clean up, then re-install the latest structure):

```bash
# Single project (with backup)
bash instructions/ai_instruction_kits/scripts/migrate-skills.sh --dry-run  # preview
bash instructions/ai_instruction_kits/scripts/migrate-skills.sh            # apply
bash instructions/ai_instruction_kits/scripts/setup-project.sh             # re-install latest structure

# Update + migrate all projects under downstream/ at once
bash scripts/update-downstream.sh --migrate
```

## Claude Code Agent Feature

Supports automation of large-scale analysis and investigation tasks using Claude Code's Task tool (agent feature).

### Use Cases
- Project-wide code quality analysis
- Comprehensive dependency investigation
- Thorough test coverage verification
- Documentation and code consistency validation

See [Claude Code Agent Usage Guide](instructions/en/system/CLAUDE_CODE_AGENT.md) for details.

## Task Management, Progress Tracking, and Worktree

For task management, progress tracking, Git worktree, and build detection, use your AI tool's native features (Claude Code's Todo, worktree, build detection). These are standard in modern AI agents, so no dedicated skills are provided.

## Migration from v1

If you were using the modular instruction system (v1):

1. The `modular/` directory is archived in the `archive/v1-modular` branch
2. Presets have been replaced by marketplace skills (e.g., `web_api_production` -> `web-api-dev` skill)
3. `.claude/commands/` is replaced by `.claude/skills/`
4. No Python environment is needed
5. Run `setup-project.sh` again to install the core skill (commit-safe)

## Writing Instructions

- Be clear and specific
- Include examples of expected output
- Clearly state any constraints
- **Always include license information** (see [LICENSE-NOTICE.md](LICENSE-NOTICE_en.md) for details)

## Project Website

For detailed information, demos, and usage examples:

**[https://dobachi.github.io/AI_Instruction_Kits/](https://dobachi.github.io/AI_Instruction_Kits/)**

## License

This repository contains multiple licenses:

- **Default**: MIT License (see [LICENSE](LICENSE))
- **Individual instructions**: The license specified in each file takes precedence

See [LICENSE-NOTICE.md](LICENSE-NOTICE_en.md) for details.
