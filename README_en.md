# AI Instruction Kits Repository

English | [日本語](README.md) | [📖 Project Website](https://dobachi.github.io/AI_Instruction_Kits/)

This repository manages instruction sheets for AI systems.

## 🚀 Quick Start (30-second setup)

### One-liner Installation (Automatic Mode)

```bash
# Auto-install with default settings
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash
```

### Quick Setup with Presets

```bash
# For Web API development
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --preset web_api --force

# For CLI tool development
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash -s -- --preset cli_tool --force
```

### Interactive Mode

```bash
# Method 1: Download then run (recommended)
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh -o install.sh
bash install.sh
rm install.sh

# Method 2: Process substitution (bash 4.0+)
bash <(curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh)
```

See the [Quick Start Guide](docs/QUICKSTART.md) for more details.

## Directory Structure

```
.
├── docs/          # Human-readable documentation
│   └── examples/  # Usage examples
│       ├── ja/    # Japanese examples
│       └── en/    # English examples
├── instructions/  # AI instruction sheets
│   ├── ja/        # Japanese instructions
│   │   ├── system/    # System management instructions
│   │   ├── general/   # General instructions
│   │   ├── coding/    # Coding-related instructions
│   │   ├── writing/   # Writing-related instructions
│   │   ├── analysis/  # Analysis-related instructions
│   │   ├── creative/  # Creative-related instructions
│   │   └── agent/     # Agent-type instructions
│   └── en/        # English instructions
│       ├── system/    # System management instructions
│       ├── general/   # General instructions
│       ├── coding/    # Coding-related instructions
│       ├── writing/   # Writing-related instructions
│       ├── analysis/  # Analysis-related instructions
│       ├── creative/  # Creative-related instructions
│       └── agent/     # Agent-type instructions
├── templates/     # Various templates
│   ├── ja/        # Japanese templates
│   │   ├── instruction_template.md  # Instruction creation template
│   │   └── PROJECT_TEMPLATE.md      # PROJECT.md template
│   └── en/        # English templates
│       ├── instruction_template.md  # Instruction creation template
│       └── PROJECT_TEMPLATE.md      # PROJECT.en.md template
├── modular/       # Modular instruction system (new feature)
│   ├── ja/        # Japanese modules
│   │   ├── modules/   # Reusable modules
│   │   ├── presets/   # Predefined combinations
│   │   └── templates/ # Generation templates
│   └── en/        # English modules
├── .claude/       # Claude Code custom commands (new feature)
│   └── commands/  # Custom command definitions
│       ├── checkpoint.md       # Checkpoint management command
│       ├── commit-and-report.md # Commit & Issue report
│       ├── commit-safe.md      # Clean commit
│       └── reload-instructions.md # Reload instructions
├── reports/       # Feedback and reports
│   └── presets/   # Preset-related reports
└── scripts/       # Tools and utilities
    ├── setup-project.sh        # Project integration setup script
    ├── checkpoint.sh           # Checkpoint management script (extended)
    ├── generate-instruction.sh # Modular instruction generation script
    ├── generate-all-presets.sh # Generate all presets at once
    ├── monitor-presets.sh      # Preset management and statistics
    ├── generate-metadata.sh    # Metadata generation script
    ├── search-instructions.sh  # Instruction search script
    ├── select-instruction.py   # Python-based instruction selection tool
    └── lib/
        └── i18n.sh            # Internationalization support library
```

## Key Files

### AI Instructions
- **[instructions/en/system/ROOT_INSTRUCTION.md](instructions/en/system/ROOT_INSTRUCTION.md)** - AI operates as instruction manager
- **[instructions/en/system/CHECKPOINT_MANAGER.md](instructions/en/system/CHECKPOINT_MANAGER.md)** - Checkpoint management system
- **[instructions/en/system/MODULE_COMPOSER.md](instructions/en/system/MODULE_COMPOSER.md)** - Modular instruction generation

### Metadata System (New Feature)
Each instruction file has a corresponding `.yaml` metadata file for fast search and category filtering.

### Documentation for Humans
- **[Project Site](https://dobachi.github.io/AI_Instruction_Kits/en/)** - Detailed documentation (GitHub Pages)
  - [Quick Start](https://dobachi.github.io/AI_Instruction_Kits/en/quickstart)
  - [Usage Guide](https://dobachi.github.io/AI_Instruction_Kits/en/usage)
  - [Features](https://dobachi.github.io/AI_Instruction_Kits/en/features)

## Development Setup (For OpenHands Users)

### Python Environment Setup (Using uv)

For those who want to use OpenHands for AI-assisted development of this project:

```bash
# Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Clone the project
git clone https://github.com/dobachi/AI_Instruction_Kits.git
cd AI_Instruction_Kits

# Create and activate Python virtual environment
uv venv
source .venv/bin/activate  # Linux/Mac
# or
.venv\Scripts\activate  # Windows

# Install dependencies (including OpenHands)
uv pip install -e .

# Install with development packages
uv pip install -e ".[dev]"

# Or reproduce complete environment (all packages)
uv pip install -r requirements.txt
```

### Using OpenHands

After setting up the environment, you can use OpenHands for AI-assisted development:

```bash
# Launch OpenHands
openhands
```

#### OpenHands-Specific Integration (Auto-Detection)

The AI Instruction Kits automatically detects OpenHands environments and loads a dedicated instruction set (`OPENHANDS_ROOT.md`). This enables:

- **Parallel Processing Optimization**: Automatically executes independent tasks in parallel
- **Error Recovery**: Automatically retries temporary errors
- **Progress Visualization**: Detailed reporting of task progress
- **Resource Optimization**: Batch file operations, cache utilization

When using OpenHands, `setup-project.sh` automatically links `.openhands/microagents/repo.md` to the appropriate instruction file.

## Claude Code Agent Feature

Supports automation of large-scale analysis and investigation tasks using Claude Code's Task tool (agent feature).

### Use Cases
- Project-wide code quality analysis
- Comprehensive dependency investigation
- Thorough test coverage verification
- Documentation and code consistency validation

See [Claude Code Agent Usage Guide](instructions/en/system/CLAUDE_CODE_AGENT.md) for details.

## Claude Code Custom Commands (New Feature)

### Overview

Dedicated custom commands for Claude Code users to streamline project workflows.

### Available Commands

| Command | Description | Example |
|---------|-------------|------|
| `/checkpoint` | Checkpoint management | `/checkpoint start "New feature implementation" 5` |
| `/commit-and-report` | Commit & Issue report | `/commit-and-report "Bug fix complete"` |
| `/commit-safe` | Clean commit (no AI signature) | `/commit-safe "Documentation update"` |
| `/reload-instructions` | Reload instructions | `/reload-instructions` |
| `/github-issues` 🆕 | Check GitHub Issues and organize tasks | `/github-issues` |
| `/reload-and-reset` 🆕 | Reset AI system and reload instructions | `/reload-and-reset` |
| `/build` 🆕 | Execute project-appropriate build commands | `/build --prod` |

### Automatic Setup

The `.claude/commands/` directory is automatically configured when running `setup-project.sh`.

```bash
# Automatic setup including custom commands
bash scripts/setup-project.sh
```

## Uninstallation

To remove AI Instruction Kits from your project:

```bash
# Normal uninstallation (with confirmation prompt)
bash scripts/uninstall.sh

# Run without confirmation
bash scripts/uninstall.sh --force

# Check what would be removed (dry-run mode)
bash scripts/uninstall.sh --dry-run

# Execute directly from remote
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/uninstall.sh | bash
```

### Items Removed
- `instructions/ai_instruction_kits/` (submodule/clone/copy)
- Symbolic links in `scripts/` directory
- Configuration files like `CLAUDE.md`, `GEMINI.md`, `CURSOR.md`
- `.claude/commands/` (custom commands)
- `.openhands/microagents/repo.md`
- `.git/hooks/prepare-commit-msg`
- Backup files (optional)

### Items Kept
- `instructions/PROJECT.md` (project-specific configuration)
- `checkpoint.log` (checkpoint log)
- Generated instruction files

For details, run `bash scripts/uninstall.sh --help`.

## Usage

### Project Integration (Recommended)

The easiest way to integrate the AI instruction system into your project:

```bash
# Run in your project's root directory
bash path/to/AI_Instruction_Kits/scripts/setup-project.sh
```

#### Integration Modes (Choose from 3)

```bash
# Interactive selection (default)
bash scripts/setup-project.sh

# Direct mode specification
bash scripts/setup-project.sh --copy      # Copy mode
bash scripts/setup-project.sh --clone     # Clone mode
bash scripts/setup-project.sh --submodule # Submodule mode (recommended)
```

**Mode Characteristics:**

| Mode | Description | Benefits | Update Method |
|------|-------------|----------|---------------|
| **copy** | Direct file copy | • No Git required<br>• Simplest option<br>• Works offline | Manual re-run |
| **clone** | Independent Git repository | • Freely modifiable<br>• Preserves history<br>• Custom changes | `git pull` |
| **submodule** | Git submodule (recommended) | • Version pinning<br>• Parent repo integration<br>• Standard management | `git submodule update --remote` |

#### Using Custom Repositories

```bash
# Use a forked repository
bash scripts/setup-project.sh --url https://github.com/yourname/AI_Instruction_Kits.git --clone

# Use a private repository (requires pre-authentication)
bash scripts/setup-project.sh --url git@github.com:company/private-instructions.git --submodule

# Use internal GitLab
bash scripts/setup-project.sh --url https://gitlab.company.com/team/ai-instructions.git --submodule
```

#### Other Options

```bash
# Force mode - runs automatically without confirmation (for CI/CD)
bash scripts/setup-project.sh --submodule --force

# Dry-run mode - shows what would be done (no actual changes)
bash scripts/setup-project.sh --dry-run

# No backup mode - overwrites existing files directly
bash scripts/setup-project.sh --force --no-backup

# Show help
bash scripts/setup-project.sh --help
```

This automatically sets up:

```
your-project/
├── scripts/
│   └── checkpoint.sh → ../instructions/ai_instruction_kits/scripts/checkpoint.sh
├── instructions/
│   ├── ai_instruction_kits/  # Submodule (this repository)
│   ├── PROJECT.md            # Project-specific settings (Japanese)
│   └── PROJECT.en.md         # Project-specific settings (English)
├── CLAUDE.md → instructions/PROJECT.en.md
├── GEMINI.md → instructions/PROJECT.en.md
└── CURSOR.md → instructions/PROJECT.en.md
```

Usage example:
```bash
# Simple AI instructions
claude "Please refer to CLAUDE.en.md and implement user authentication"
```

### Basic Usage (Manual)

1. **Using a single instruction**
   ```bash
   # Specify file path directly
   claude "Refer to instructions/en/coding/basic_code_generation.md and..."
   ```

2. **Using automatic selection**
   ```bash
   # Make AI operate as instruction manager
   claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md and analyze sales data to create a report"
   ```

3. **Using search function (new feature)**
   ```bash
   # Search by keyword
   ./scripts/search-instructions.sh python
   
   # Filter by category
   ./scripts/search-instructions.sh -c coding -l en
   
   # Show detailed information
   ./scripts/search-instructions.sh -f detail marp
   
   # Search with Python tool
   python3 scripts/select-instruction.py --search "API development"
   ```

### Adding New Instructions

1. Save instruction sheets in the appropriate category and language directory
2. Use descriptive filenames
3. Markdown format (.md) is recommended
4. Generate metadata for searchability
   ```bash
   # Generate metadata for a single file
   ./scripts/generate-metadata.sh instructions/en/coding/my_new_instruction.md
   
   # Regenerate all metadata
   ./scripts/generate-metadata.sh
   ```

### Customizing PROJECT.md

After setup, `instructions/PROJECT.md` is copied from `templates/en/PROJECT_TEMPLATE.md`.
By editing the template beforehand, you can apply common settings to all new projects.

```bash
# Example of customizing templates
vi templates/ja/PROJECT_TEMPLATE.md
vi templates/en/PROJECT_TEMPLATE.md
```

## Preset System (Fast Response, Top Priority)

### Overview

Presets are pre-generated instructions optimized for common tasks. Compared to dynamic generation, they can be used immediately, significantly reducing response time.

**Important**: AI uses presets with top priority for standard tasks. The modular system is used only when customization is needed.

### Available Presets

| Preset Name | Use Case | Path |
|------------|----------|------|
| **web_api_production** | Production Web API Development | `instructions/en/presets/web_api_production.md` |
| **cli_tool_basic** | CLI Tool Development | `instructions/en/presets/cli_tool_basic.md` |
| **data_analyst** | Data Analysis Tasks | `instructions/en/presets/data_analyst.md` |
| **technical_writer** | Technical Documentation | `instructions/en/presets/technical_writer.md` |
| **academic_researcher** | Academic Research Support | `instructions/en/presets/academic_researcher.md` |
| **business_consultant** | Business Consulting | `instructions/en/presets/business_consultant.md` |
| **project_manager** | Project Management | `instructions/en/presets/project_manager.md` |
| **startup_advisor** | Startup Support | `instructions/en/presets/startup_advisor.md` |

### How to Use Presets

```bash
# Example: Web API Development Task
claude "Create a REST API"
# → AI automatically uses web_api_production preset

# Example: Data Analysis Task
claude "Analyze sales data"
# → AI automatically uses data_analyst preset
```

### Managing Presets

```bash
# Regenerate all presets
./scripts/generate-all-presets.sh

# Regenerate specific preset only
./scripts/generate-all-presets.sh --preset web_api_production

# Check preset integrity
./scripts/monitor-presets.sh check

# Display preset usage statistics
./scripts/monitor-presets.sh stats
```

### Automatic Updates

Presets are automatically updated at:
- When modules are updated (GitHub Actions)
- Manual trigger (GitHub Actions workflow_dispatch)

For detailed usage guide, see [docs/guides/PRESET_USAGE_GUIDE.md](docs/guides/PRESET_USAGE_GUIDE.md).

## Modular Instruction System (New Feature)

### Overview

Presets are pre-generated instructions optimized for common tasks. Compared to dynamic generation, they can be used immediately, significantly reducing response time.

### Available Presets

| Preset Name | Use Case | Path |
|------------|----------|------|
| **web_api_production** | Production Web API Development | `instructions/en/presets/web_api_production.md` |
| **cli_tool_basic** | CLI Tool Development | `instructions/en/presets/cli_tool_basic.md` |
| **data_analyst** | Data Analysis Tasks | `instructions/en/presets/data_analyst.md` |
| **technical_writer** | Technical Documentation | `instructions/en/presets/technical_writer.md` |
| **academic_researcher** | Academic Research Support | `instructions/en/presets/academic_researcher.md` |
| **business_consultant** | Business Consulting | `instructions/en/presets/business_consultant.md` |
| **project_manager** | Project Management | `instructions/en/presets/project_manager.md` |
| **startup_advisor** | Startup Support | `instructions/en/presets/startup_advisor.md` |

### How to Use Presets

```bash
# Example: Web API Development Task
claude "Create a REST API"
# → AI automatically uses web_api_production preset

# Example: Data Analysis Task
claude "Analyze sales data"
# → AI automatically uses data_analyst preset
```

### Managing Presets

```bash
# Regenerate all presets
./scripts/generate-all-presets.sh

# Regenerate specific preset only
./scripts/generate-all-presets.sh --preset web_api_production

# Check preset integrity
./scripts/monitor-presets.sh check

# Display preset usage statistics
./scripts/monitor-presets.sh stats
```

### Automatic Updates

Presets are automatically updated at:
- When modules are updated (GitHub Actions)
- Manual trigger (GitHub Actions workflow_dispatch)

For detailed usage guide, see [docs/guides/PRESET_USAGE_GUIDE.md](docs/guides/PRESET_USAGE_GUIDE.md).

The modular instruction system generates custom instructions by combining reusable modules.
Customization based on presets is also possible.

### Basic Usage

```bash
# Use a preset (automatically selects optimal method)
./scripts/generate-instruction.sh --preset web_api_production --output api.md
# → If pre-generated version is up-to-date: instant use (0 seconds)
# → If modules have been updated: automatic regeneration

# Customize a preset (new feature)
./scripts/generate-instruction.sh --preset web_api_production \
  --modules skill_testing skill_deployment \
  --variable framework=FastAPI

# Specify modules directly
./scripts/generate-instruction.sh \
  --modules core_role_definition task_code_generation skill_error_handling \
  --output custom.md

# AI analysis for module recommendation (--metadata option)
./scripts/generate-instruction.sh --metadata \
  --prompt "Web service development with RESTful API and database integration"
```

### Available Presets

```bash
# List presets
./scripts/generate-instruction.sh --list presets
```

### Available Modules

```bash
# List modules
./scripts/generate-instruction.sh --list modules
```

### Examples of Preset Customization

1. **Web API + Additional Features**
   ```bash
   ./scripts/generate-instruction.sh \
     --preset web_api_production \
     --modules skill_caching skill_monitoring
   ```

2. **Technical Writer + Code Documentation**
   ```bash
   ./scripts/generate-instruction.sh \
     --preset technical_writer \
     --modules skill_code_documentation \
     --variable code_language=Python
   ```

3. **Data Analysis + Visualization**
   ```bash
   ./scripts/generate-instruction.sh \
     --preset data_analyst \
     --modules skill_data_visualization \
     --variable visualization_tool=matplotlib
   ```

For details, see [instructions/en/system/MODULE_COMPOSER.md](instructions/en/system/MODULE_COMPOSER.md).

## Checkpoint Management System (Extended Version)

### Overview

An advanced management system that tracks task progress and records instruction usage history.

### Extended Features

```bash
# Track instruction usage
scripts/checkpoint.sh instruction-start "instructions/en/presets/web_api_production.md" "API development" TASK-123
scripts/checkpoint.sh instruction-complete "instructions/en/presets/web_api_production.md" "3 endpoints implemented" TASK-123

# AI-friendly concise output mode
scripts/checkpoint.sh ai pending
scripts/checkpoint.sh ai progress TASK-123 2 5 "Implementing" "Creating tests"

# Display usage statistics
scripts/checkpoint.sh stats

# Instruction usage history
scripts/checkpoint.sh history
```

### Workflow Constraints

- Progress reporting is only possible during instruction usage
- All instructions must be completed when finishing a task
- Task IDs are automatically generated for consistency

### Feedback and Reports

Please help improve presets:
- Feedback recording: `reports/presets/feedback/current.md`
- Monitoring reports: `reports/presets/monitoring/`
- See [reports/README.md](reports/README.md) for details

## How to Write Instructions

- Be clear and specific
- Include examples of expected output
- Clearly state any constraints
- **Always include license information** (see [LICENSE-NOTICE.md](LICENSE-NOTICE_en.md) for details)

## 📖 Project Website

For detailed information, demos, and usage examples, visit:

🌐 **[https://dobachi.github.io/AI_Instruction_Kits/](https://dobachi.github.io/AI_Instruction_Kits/)**

- Quick Start Guide
- Feature Details
- Practical Examples

## License

This repository contains multiple licenses:

- **Default**: MIT License (see [LICENSE](LICENSE))
- **Individual instructions**: The license specified in each file takes precedence

See [LICENSE-NOTICE.md](LICENSE-NOTICE_en.md) for details.