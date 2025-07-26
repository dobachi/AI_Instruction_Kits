---
layout: default
title: AI Instruction Kits
description: Features - Detailed explanation of all features
lang: en
---

# Features

Detailed introduction to all features of AI Instruction Kits.

## 🧩 NEW! Modular Instruction System

### Overview
Revolutionary feature released in July 2025 that dynamically generates instructions based on project requirements.

### MODULE_COMPOSER
Analyzes tasks and automatically generates customized instructions by combining optimal modules.

**Key Features:**
- **Automatic task analysis**: Just input tasks in natural language
- **Intelligent selection**: Uses metadata to select optimal modules
- **Flexible combination**: Can integrate multiple modules
- **Default value support**: Start with minimal configuration

### 🚀 Pre-generated Presets (Fast & Recommended)

Pre-generated instructions that can be used immediately with **0-second response time**.

#### Available Presets (8 types)

1. **web_api_production**: Production Web API Development
   - RESTful API design, security implementation, documentation generation
   - Path: `instructions/en/presets/web_api_production.md`

2. **cli_tool_basic**: CLI Tool Development
   - Command line parsing, error handling, distribution preparation
   - Path: `instructions/en/presets/cli_tool_basic.md`

3. **data_analyst**: Data Analysis Tasks
   - Data preprocessing, statistical analysis, visualization, report creation
   - Path: `instructions/en/presets/data_analyst.md`

4. **technical_writer**: Technical Documentation
   - API documentation, user guides, technical blogs, README creation
   - Path: `instructions/en/presets/technical_writer.md`

5. **academic_researcher**: Academic Research Support
   - Literature review, paper writing, citation management, research planning
   - Path: `instructions/en/presets/academic_researcher.md`

6. **business_consultant**: Business Consulting
   - Market analysis, strategy planning, presentation creation, ROI calculation
   - Path: `instructions/en/presets/business_consultant.md`

7. **project_manager**: Project Management
   - Task management, resource allocation, progress tracking, risk management
   - Path: `instructions/en/presets/project_manager.md`

8. **startup_advisor**: Startup Support
   - Business model, pitch deck, fundraising, MVP development
   - Path: `instructions/en/presets/startup_advisor.md`

#### Benefits of Presets

- **Immediately available**: No generation wait time (0 seconds)
- **Optimized**: Specialized for commonly used tasks
- **Quality assured**: Tested and highly reliable
- **Auto-updated**: Automatically regenerated when modules change

### Expertise Modules (5 types)

1. **software_engineering**: Latest software engineering compliant with SWEBOK v4.0
2. **legal_engineering**: Legal engineering and regulatory technology expertise
3. **machine_learning**: ML/AI design, implementation, and operations
4. **parallel_distributed**: Parallel and distributed system expertise
5. **data_space**: Data space construction including GAIA-X, IDS

### Module Types

- **Core**: Defines basic system structure
- **Tasks**: Specific work content (code generation, data analysis, documentation, etc.)
- **Skills**: Specific abilities (API design, testing, error handling, etc.)
- **Methods**: Work approaches (agile, lean, design thinking, etc.)
- **Domains**: Industry-specific knowledge (finance, healthcare, education, etc.)
- **Roles**: AI behavior (mentor, reviewer, consultant, etc.)
- **Quality**: Quality levels and standards
- **Expertise**: Deep expertise and latest best practices

### Usage Examples
```bash
# Writing academic papers
claude "Write a research paper"
# → MODULE_COMPOSER selects academic_researcher preset
# → Also adds citation management, methodology design, statistical analysis modules

# Data analysis
claude "Analyze sales data"
# → data_analyst preset is automatically selected
# → Combines visualization, statistical processing, report creation modules

# Specialized tasks
claude "Design a distributed system"
# → parallel_distributed expertise module is selected
# → Design based on 2024-2025 latest technology trends
```

## 📚 Instruction Categories

### 1. System Management
Basic instructions to control AI behavior

- **ROOT_INSTRUCTION.md** - Operates as instruction manager
- **INSTRUCTION_SELECTOR.md** - Keyword-based automatic selection
- **CHECKPOINT_MANAGER.md** - Progress management system

### 2. General Tasks
General-purpose instructions for daily tasks

- **basic_qa.md** - Q&A, information provision
- Project management support
- Documentation assistance

### 3. Coding
Instructions specialized for programming tasks

- **basic_code_generation.md** - Basics of code generation
- Debugging support
- Refactoring guidance
- Test code creation

### 4. Writing
For document and content creation

- **basic_text_creation.md** - Basic text creation
- **presentation_creation.md** - Presentation structure
- Technical documentation
- Marketing content

### 5. Analysis
For data analysis and research tasks

- **basic_data_analysis.md** - Basics of data analysis
- Market research support
- Competitive analysis
- Performance analysis

### 6. Creative
Support for creative tasks

- **basic_creative_work.md** - Idea generation
- Design proposals
- Storytelling
- Brainstorming

### 7. Agent-based
Instructions to behave as specific experts

- **python_expert.md** - Python development expert
- **code_reviewer.md** - Code reviewer
- **technical_writer.md** - Technical writer

## 🔧 Core Features

### Checkpoint Management

Automatically record and track work progress

```bash
# Task start
[1/5] Started | Next: Analysis
📌 Record→checkpoint.log: [timestamp][task ID][START] Task name

# Progress update
[3/5] Implementation complete | Next: Testing
📌 Record→checkpoint.log: Records only at start/error/completion

# Task completion
[✓] All complete | Result: Detailed results
```

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

### Checkpoint Log Analysis

Quantitatively understand work progress and results.

#### Basic Statistics
```bash
# Total completed tasks
grep "COMPLETE" checkpoint.log | wc -l

# Check running tasks (incomplete)
grep "START" checkpoint.log | grep -v "COMPLETE"

# Today's task list
grep "$(date +%Y-%m-%d)" checkpoint.log

# Extract tasks with errors
grep "ERROR" checkpoint.log
```

#### Task Analysis Example
```bash
# Script example to calculate time per task ID
#!/bin/bash
while read -r line; do
    if [[ $line =~ \[TASK-([a-f0-9]+)\] ]]; then
        task_id="${BASH_REMATCH[1]}"
        # Find START/COMPLETE pairs and calculate time difference
        # (Implementation details omitted)
    fi
done < checkpoint.log
```

### Project Customization Analysis

Understand project characteristics from PROJECT.md contents:

```bash
# Check project settings
cat instructions/PROJECT.md | grep -E "(Build command|Lint command|Test framework)"

# Count customized items
grep -v "^#" instructions/PROJECT.md | grep -v "^$" | grep -v "Example:" | wc -l
```

### Deliverable Quantification

Extract results from checkpoint log:

```bash
# Generate deliverable summary
grep "Result:" checkpoint.log | sed 's/.*Result: //' | sort | uniq -c | sort -nr

# Count created files, tests, etc.
grep "Result:" checkpoint.log | grep -E "[0-9]+ (files|tests|endpoints)"
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
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/tree/main/instructions">View all instructions</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/blob/main/docs/HOW_TO_USE_en.md">Detailed usage guide</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/issues/new">Feature requests</a></li>
  </ul>
</div>