# AI Instruction Kits Development Support Configuration

This project is a meta-project for developing and improving the AI instruction system itself.
When starting a task, please load `instructions/en/system/ROOT_INSTRUCTION.md`.

**Important**: ROOT_INSTRUCTION.md is a skill orchestrator. Check installed skills and use them according to the task.

## Important: Path Translation

When using instructions in this project itself, **path translation is required**:

### Normal Project Usage (via submodule)
```
instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md
scripts/checkpoint.sh
```

### Usage in This Project Itself
```
instructions/en/system/ROOT_INSTRUCTION.md
scripts/checkpoint.sh
```

### Path Conversion Rules
- `instructions/ai_instruction_kits/instructions/` → `instructions/`
- `instructions/ai_instruction_kits/` → root directory

## Project Overview
- **Purpose**: Development of a system to structurally manage and provide instructions to AI
- **Language**: Japanese priority (maintaining English version simultaneously)
- **License**: Apache-2.0 (individual instructions have their own licenses)
- **Architecture**: Skill-based (v2.0) - 4 core skills maintained locally, others via marketplace

## Skill-Based Architecture (v2.0)

### Core Skills (maintained locally)
| Skill | Purpose |
|-------|---------|
| checkpoint-manager | Task progress tracking and management |
| worktree-manager | Git worktree management |
| auto-build | Project build automation |
| commit-safe | Safe commits |

### Additional Skills
Install from marketplace: https://github.com/dobachi/claude-skills-marketplace

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

## Codex CLI Custom Commands

Codex-specific prompt files live in `.codex/prompts/`. The file name becomes the `/command` (for example `build.md` → `/build`). Copy the files to your local `~/.codex/prompts/` and restart the CLI to make them available.

- `build` — assists with detecting the project type and running the appropriate build
- `checkpoint` — wraps `scripts/checkpoint.sh` subcommands
- `commit-and-report` — guides commit, push, and optional issue updates
- `commit-safe` — walks through safe, file-scoped commits
- `github-issues` — gathers and summarizes open GitHub issues
- `reload-instructions` — updates the instruction submodule and reloads ROOT_INSTRUCTION
- `reload-and-reset` — refreshes instructions and reiterates the operating rules

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

# Execute checkpoint in this project itself
bash scripts/checkpoint.sh

# Clean commit (without AI messages)
bash scripts/commit.sh "commit message"
```

## Git Worktree Usage (Recommended)
For complex tasks or multi-file changes, work in a dedicated worktree:

```bash
# Start task
scripts/checkpoint.sh start "Feature development" 3
# → Task ID: TASK-123456-abc

# Create worktree
scripts/worktree-manager.sh create TASK-123456-abc "feature-dev"
cd .gitworktrees/ai-TASK-123456-abc-feature-dev/

# Do work...

# Complete
scripts/checkpoint.sh complete TASK-123456-abc "Done"
scripts/worktree-manager.sh complete TASK-123456-abc
```

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
# Update submodules in all downstream projects
for repo in downstream/*/; do
  (cd "$repo" && git submodule update --remote instructions/ai_instruction_kits && git add -A && git commit -m "chore: update ai_instruction_kits submodule" && git push)
done
```

## Commit Rules
- **Required**: `bash scripts/commit.sh "message"` or `git commit -m "message"`
- **Prohibited**: Commits with AI signatures (auto-detected and rejected)

---
## License Information
- **License**: MIT
- **Created**: 2025-01-03
