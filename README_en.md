# AI Instruction Kits Repository

English | [日本語](README.md)

This repository manages instruction sheets for AI systems.

## Directory Structure

```
.
├── docs/          # Human-readable documentation
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
│       └── creative/  # Creative-related instructions
├── examples/      # Usage examples
│   ├── ja/        # Japanese examples
│   └── en/        # English examples
├── templates/     # Instruction templates
│   ├── ja/        # Japanese templates
│   └── en/        # English templates
└── tools/         # Tools and utilities
    └── setup-project.sh  # Project integration setup script
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
bash path/to/AI_Instruction_Kits/tools/setup-project.sh
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