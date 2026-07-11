# AI Instruction Kits Development Support Configuration

This project is a meta-project for developing and improving the AI instruction system itself.
When starting a task, please load `instructions/en/system/ROOT_INSTRUCTION.md`.

**Important**: ROOT_INSTRUCTION.md is a skill orchestrator. Check installed skills and use them according to the task.

## Important: Path Translation

When using instructions in this project itself, **path translation is required**:

### Normal Project Usage (via submodule)
```
instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md
scripts/commit.sh
```

### Usage in This Project Itself
```
instructions/en/system/ROOT_INSTRUCTION.md
scripts/commit.sh
```

### Path Conversion Rules
- `instructions/ai_instruction_kits/instructions/` → `instructions/`
- `instructions/ai_instruction_kits/` → root directory

## Project Overview
- **Purpose**: Development of a system to structurally manage and provide instructions to AI
- **Language**: Japanese priority (maintaining English version simultaneously)
- **License**: Apache-2.0 (individual instructions have their own licenses)
- **Architecture**: Skill-based (v2.0) - all skills consolidated in the marketplace (this repo ships no skills)

## Skill-Based Architecture (v2.0)

### Skill Distribution
All skills — including commit-safe — are distributed via the external marketplace. This repository is not a marketplace; it focuses on the instruction set itself.

- Marketplace: https://github.com/dobachi/claude-skills-marketplace
- Install: `/plugin marketplace add dobachi/claude-skills-marketplace` → `/plugin install commit-safe@dobachi-skills`

> Use your AI tool's native features for task management, progress tracking, Git worktrees, and builds.

## Development Principles

### 1. Structural Clarity
- Directory structure must be intuitively understandable
- Naming conventions must be consistent
- Categorization must be practical

### 2. Ease of Use
- Minimal steps to start using
- Easy integration with existing projects
- Documentation must include examples

### 3. Extensibility
- Easy to add new skills
- Flexible customization
- Ability to support other AI tools

## Important Development Considerations

### When Editing Files
1. **Japanese-English Synchronization**: Always update English version when updating Japanese version
2. **Examples First**: Prioritize concrete examples over abstract explanations
3. **Path Descriptions**: Paths in instructions should assume submodule usage

### When Adding New Features
1. First implement and verify in Japanese version
2. Create English version
3. Update samples and templates
4. Update README and documentation

### Testing and Verification
1. Verify setup-project.sh works correctly
2. Verify each skill functions independently
3. Verify path consistency (operation in submodule environment)

## Claude Code Agent Feature Usage

For project analysis and large-scale investigation tasks, actively use the Agent tool (Task tool):

### Recommended Use Cases
- Skill quality checks and duplicate detection
- Identifying unused code
- Dependency analysis
- Documentation and code consistency verification

## Using skills across CLIs (Codex / Gemini / Antigravity)

Each tool has its own instruction file (all symlinks to `PROJECT_META.md`):

- Claude Code → `CLAUDE.md`
- Codex CLI → `CODEX.md`
- Gemini CLI → `GEMINI.md`
- Antigravity CLI (`agy`) → `AGENTS.md`

**All skills are consolidated in the external marketplace.** This repository no longer ships local `.codex/prompts/`, `.gemini/commands/`, or `.agents/skills/`. Because these CLIs share the Agent Skills standard (`~/.agents/skills/<name>/SKILL.md`), running the marketplace `install.sh` once makes the skills available to Claude Code, Codex, Gemini, and Antigravity alike.

```bash
git clone https://github.com/dobachi/claude-skills-marketplace
bash claude-skills-marketplace/install.sh
```

Claude Code can also use the plugin flow: `/plugin marketplace add dobachi/claude-skills-marketplace` → `/plugin install commit-safe@dobachi-skills`.

## Project-Specific Instructions

### Coding Standards
- Shell scripts: POSIX compliant, error handling required
- Markdown: Maximum 3 heading levels, language specification for code blocks
- Filenames: snake_case (lowercase letters and underscores)

### Commit Messages
```
<type>: <description>

- feat: New feature
- fix: Bug fix
- docs: Documentation update
- refactor: Refactoring
- test: Test addition/modification
```

### Pull Requests
- Clearly state purpose and scope of changes
- Include related issue numbers
- Confirm both Japanese and English updates

## Frequently Used Commands

```bash
# Integration test
bash scripts/setup-project.sh

# Clean commit (without AI messages)
bash scripts/commit.sh "commit message"
```

## Task Management & Progress Tracking
Use your AI tool's native features for task management, progress tracking, Git worktrees, and builds.

## Downstream Projects (downstream/)

The `downstream/` directory contains clones of repositories that use this project as a submodule (`.gitignored`).
When this project is updated, their submodule references need to be updated as well.

| Repository | Purpose |
|-----------|---------|
| ResearchTemplate | Research project template |
| DevProjectTemplate | Development project template |
| PresentationTemplate | Presentation template |
| DeliberationTemplate | Deliberation template |

### Update procedure
```bash
# Update all downstream repos
bash scripts/update-downstream.sh

# Dry run (check only)
bash scripts/update-downstream.sh --dry-run

# Specific repo only
bash scripts/update-downstream.sh ResearchTemplate
```

## Commit Rules
- **Required**: `bash scripts/commit.sh "message"` or `git commit -m "message"`
- **Prohibited**: Commits with AI signatures (auto-detected and rejected)

---
## License Information
- **License**: MIT
- **Created**: 2025-01-03
