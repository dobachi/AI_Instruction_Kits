# AI Instruction Kits Repository

English | [日本語](README.md)

This repository manages instruction sheets for AI systems.

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
│   │   └── creative/  # Creative-related instructions
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
└── scripts/       # Tools and utilities
    ├── setup-project.sh  # Project integration setup script
    └── checkpoint.sh     # Checkpoint management script
```

## Key Files

### AI Instructions
- **[instructions/en/system/ROOT_INSTRUCTION.md](instructions/en/system/ROOT_INSTRUCTION.md)** - AI operates as instruction manager
- **[instructions/en/system/INSTRUCTION_SELECTOR.md](instructions/en/system/INSTRUCTION_SELECTOR.md)** - Keyword-based automatic selection

### Human Documentation
- **[docs/HOW_TO_USE_en.md](docs/HOW_TO_USE_en.md)** - Detailed usage guide (for humans)
- **[USAGE_GUIDE.md](USAGE_GUIDE.md)** - Usage overview

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
- `instructions/ai_instruction_kits/` submodule
- `instructions/PROJECT.md` - Japanese project configuration
- `instructions/PROJECT.en.md` - English project configuration
- AI product-specific symbolic links (CLAUDE.md, GEMINI.md, CURSOR.md)

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
   
   # Keyword-based automatic selection
   claude "Refer to instructions/en/system/INSTRUCTION_SELECTOR.md and implement a Web API"
   ```

### Adding New Instructions

1. Save instruction sheets in the appropriate category and language directory
2. Use descriptive filenames
3. Markdown format (.md) is recommended

### Customizing PROJECT.md

After setup, `instructions/PROJECT.md` is copied from `templates/en/PROJECT_TEMPLATE.md`.
By editing the template beforehand, you can apply common settings to all new projects.

```bash
# Example of customizing templates
vi templates/ja/PROJECT_TEMPLATE.md
vi templates/en/PROJECT_TEMPLATE.md
```

## How to Write Instructions

- Be clear and specific
- Include examples of expected output
- Clearly state any constraints
- **Always include license information** (see [LICENSE-NOTICE.md](LICENSE-NOTICE_en.md) for details)

## License

This repository contains multiple licenses:

- **Default**: Apache License 2.0 (see [LICENSE](LICENSE))
- **Individual instructions**: The license specified in each file takes precedence

See [LICENSE-NOTICE.md](LICENSE-NOTICE_en.md) for details.