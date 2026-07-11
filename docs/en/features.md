---
layout: default
title: AI Instruction Kits
description: Features - Detailed explanation of all features
lang: en
---

# Features

Detailed introduction to all features of AI Instruction Kits.

## 🧩 v2.0 Skill-Based Architecture

### Overview
The v2.0 skill-based architecture enables automatic selection and execution of skills tailored to each task.

### Skill Orchestrator (ROOT_INSTRUCTION)
Analyzes tasks and automatically selects the optimal skills from `.claude/skills/` to execute them.

**Key Features:**
- **Automatic task analysis**: Just input tasks in natural language
- **Intelligent selection**: Selects optimal skills based on task content
- **Marketplace integration**: Install skills from the marketplace
- **Start with minimal config**: Get started with just commit-safe

### Skills come from the marketplace

All skills, including commit-safe, are installed from the [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace). This repository ships no skills of its own.

```text
/plugin marketplace add dobachi/claude-skills-marketplace
/plugin install commit-safe@dobachi-skills
```

- **commit-safe**: Safe commits
   - Clean commits without AI signatures (bundles a self-contained commit.sh)
   - File-specific safe commit workflow

For task management (Todo), progress tracking, Git worktree, and build detection, use your AI tool's native features (Claude Code's Todo, worktree, build detection), since modern AI agents ship with these built in.

Installed skills are auto-selected and used from `.claude/skills/`.

### Usage Examples
```bash
# Skill orchestrator automatically selects skills
claude "Implement a new feature"
# → ROOT_INSTRUCTION analyzes the task
# → AI tool's native features manage progress and work (Todo / worktree / build detection)
# → commit-safe performs clean commits

# Safe commits
claude "Commit my changes"
# → commit-safe skill commits without AI signatures
```

## 📚 Skills and Customization

### System Instructions
- **ROOT_INSTRUCTION.md** - Skill orchestrator (auto-selects optimal skills from `.claude/skills/`)

### Skills (installed from the marketplace)
| Skill | Purpose | Auto-suggestion Timing |
|-------|---------|----------------------|
| commit-safe | Safe commits | Suggest file-specific commit after changes |

For task management (Todo), progress tracking, Git worktree, and build detection, use your AI tool's native features.

### Marketplace Skills

Install additional specialized skills from [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace).

| Category | Example Skills |
|----------|---------------|
| Development Tools | build, commit-and-report, github-issues |
| Role Skills | web-api-dev, data-analyst, python-expert, code-reviewer |
| Presentation | marp-slides |
| Quality | fact-checker, evidence-check |

### Custom Instructions

Add project-specific instructions under `instructions/en/`:
- `instructions/en/coding/` - Coding related
- `instructions/en/writing/` - Writing related
- `instructions/en/analysis/` - Analysis related

## 🔧 Core Features

### Claude Code Agent Feature

Automate large-scale analysis tasks using Task tool (agent feature):

- **Code Quality Analysis**: Project-wide quality checks
- **Dependency Investigation**: Comprehensive dependency mapping
- **Test Coverage**: Thorough coverage analysis
- **Documentation Verification**: Implementation consistency checks

Use Claude Code's Task tool to run sub-agents that perform parallel analysis in independent contexts. Refer to the "Claude Code Agent Feature" section in CLAUDE.md for configuration details.

### Task Management & Progress Tracking

Track work progress and instruction usage history with your AI tool's native features (Claude Code's Todo, for example). Task breakdown and progress visualization happen automatically during the conversation, so a custom checkpoint script is no longer needed.

### Example Marketplace Skills

Representative skills you can install from the [marketplace](https://github.com/dobachi/claude-skills-marketplace) (invoked by skill name / auto-triggered once installed):

| Skill | Description | Example |
|-------|-------------|------|
| `commit-and-report` | Commit & Issue report | `commit-and-report "Bug fix complete"` |
| `commit-safe` | Clean commit (no AI signature) | `commit-safe "Documentation update"` |
| `reload-instructions` | Reload instructions | `reload-instructions` |
| `github-issues` | Check GitHub issues and organize tasks | `github-issues` |
| `reload-and-reset` | Reset AI system and reload instructions | `reload-and-reset` |

### Integration Modes

Choose based on project needs

| Mode | Benefits | Use Cases |
|------|----------|-----------|
| **Copy** | • No Git<br>• Fastest setup<br>• Offline support | Small projects<br>Non-Git environments |
| **Clone** | • Full control<br>• Custom modifications<br>• History management | Large customizations<br>Custom instruction development |
| **Submodule** | • Easy updates<br>• Version control<br>• Multi-project support | Team development<br>Long-term projects |

### Custom URL Support

Use instructions from your own repository

```bash
# Corporate internal repository
--url https://gitlab.company.com/ai-team/instructions.git

# Personal fork
--url https://github.com/yourname/custom-instructions.git

# Private repository (requires authentication)
--url git@github.com:org/private-instructions.git
```

## 🎯 Advanced Usage

### 1. Creating Custom Instructions

```markdown
# Custom Instruction Template
## Purpose
Clearly describe the purpose of this instruction

## Prerequisites
- Required knowledge
- Environment requirements
- Dependencies

## Specific Instructions
1. Detailed step 1
2. Detailed step 2
3. ...

## Expected Outcomes
- Deliverable 1
- Deliverable 2

---
## License Information
- **License**: [License name]
- **Author**: [Name]
- **Date**: [Date]
```

### 2. PROJECT.md Customization

Describe project-specific settings in detail:

```markdown
## Project-specific Additional Instructions

### Architecture
- Microservices architecture
- API Gateway: Kong
- Message Queue: RabbitMQ

### Development Standards
- Commit messages: Conventional Commits
- Branch strategy: Git Flow
- Code review: Required (2+ reviewers)

### Security
- Authentication: OAuth 2.0
- Data encryption: AES-256
- Secret management: HashiCorp Vault
```

### 3. Pre-customizing Templates

```bash
# Edit templates
vi templates/en/PROJECT_TEMPLATE.md

# Add common settings applied to all new projects
- CI/CD configuration
- Standard lint rules
- Common test frameworks
```

## 🔒 Security Features

### Private Repository Support

Securely retrieve instructions from organization-specific private repositories.

#### Implementation
```bash
# Example of internal repository
bash setup-project.sh --url https://github.com/company/private-ai-instructions.git
```

- **Benefits**: Securely manage organization-specific confidential instructions
- **Use cases**: Internal coding standards, proprietary business logic, security policies

### SSH Authentication Support

Supports secure authentication using SSH keys.

#### Implementation
```bash
# Using SSH format URL
bash setup-project.sh --url git@github.com:company/private-instructions.git --submodule
```

- **Benefits**: Secure authentication without passwords, easy automation in CI/CD environments
- **Prerequisites**: SSH key setup required (`ssh-keygen` and `ssh-add`)

### Access Token Support

Supports authentication using personal access tokens from GitHub/GitLab.

#### Implementation
```bash
# Embedding token in URL
bash setup-project.sh --url https://YOUR_TOKEN@github.com/company/repo.git

# Using environment variable (more secure)
export GIT_TOKEN=your_personal_access_token
bash setup-project.sh --url https://${GIT_TOKEN}@github.com/company/repo.git
```

- **Benefits**: Fine-grained permission control, expiration settings, minimal access rights
- **Use cases**: CI/CD environments, automation scripts, temporary access

### Internal Network Support

Supports Git servers inside organizations not exposed to the internet.

#### Implementation
```bash
# Example internal GitLab server
bash setup-project.sh --url https://gitlab.company.local/team/ai-instructions.git

# Example internal Gitea server
bash setup-project.sh --url http://git.internal:3000/dev/instructions.git
```

- **Supported servers**: GitLab CE/EE, Gitea, Bitbucket Server, other Git-compatible servers
- **Benefits**: Completely internal operation, no external network required, high security

## 📦 Version Management

### Version Pinning

Pin the version of instructions used in your project to prevent unexpected changes.

#### Implementation with Submodules
```bash
# Pin to specific commit
cd instructions/ai_instruction_kits
git checkout v1.2.3  # or specific commit hash
cd ../..
git add instructions/ai_instruction_kits
git commit -m "Pin instructions to v1.2.3"
```

- **Benefits**: Ensure reproducibility, stable operation, consistency across teams
- **Use cases**: Production environments, critical projects, auditable environments

### Update Control

Manage instruction updates systematically and apply after testing.

#### Update Process
```bash
# Check latest version (without actually updating)
cd instructions/ai_instruction_kits
git fetch
git log HEAD..origin/main --oneline

# Apply update after testing
git pull origin main
cd ../..
git add instructions/ai_instruction_kits
git commit -m "Update instructions to latest version"
```

- **Workflow**: 
  1. Test new version in development environment
  2. Review and confirm changes
  3. Gradually apply to staging → production

### Rollback Feature

Instantly revert to previous stable version if issues occur.

#### Rollback Steps
```bash
# Revert to previous version
cd instructions/ai_instruction_kits
git checkout HEAD~1
cd ../..
git add instructions/ai_instruction_kits
git commit -m "Rollback instructions to previous version"

# Revert to specific stable version
cd instructions/ai_instruction_kits
git checkout v1.1.0  # Specific stable version
cd ../..
git add instructions/ai_instruction_kits
git commit -m "Rollback instructions to v1.1.0 (stable)"
```

- **Benefits**: Risk management, quick incident response, safe to try updates
- **Recommendation**: Test before and after rollback, record change history

## 📊 Usage Statistics and Metrics

### Project Customization Analysis

Understand project characteristics from PROJECT.md contents:

```bash
# Check project settings
cat instructions/PROJECT.md | grep -E "(Build command|Lint command|Test framework)"

# Count customized items
grep -v "^#" instructions/PROJECT.md | grep -v "^$" | grep -v "Example:" | wc -l
```

## 🚀 Future Plans

### Planned Features

#### 🤖 AI-powered Instruction Generation
Automatically generate instructions for new categories by learning from existing ones
- Suggest optimal instructions by analyzing project characteristics
- Combine best practices from existing instructions
- Improve based on user feedback

#### 🔍 Instruction Search and Filtering
Quickly find needed instructions even as they grow
- Tag-based classification system
- Keyword search functionality
- Dependency visualization
- Usage frequency-based recommendations

#### 📝 Version Diff Display
Easily understand what changed during updates
- Highlight changed sections
- Impact analysis
- Decision support for rollback

#### 🧪 Instruction Testing Framework
Ensure instruction quality
- Test cases for expected output
- Ambiguity checking
- Cross-AI compatibility testing

### Community Contributions
- Adding new instruction categories
- Multi-language support (Chinese, Korean, etc.)
- Industry-specific template collections
- Best practice sharing

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>📚 Learn More</h3>
  <ul>
    <li><a href="usage">Usage Guide</a></li>
    <li><a href="https://github.com/dobachi/claude-skills-marketplace">Skills Marketplace</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/issues/new">Feature requests</a></li>
  </ul>
</div>