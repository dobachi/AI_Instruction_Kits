# AI Instruction Sheet Repository

English | [日本語](README.md)

This repository manages instruction sheets for AI systems.

## Directory Structure

```
.
├── docs/          # Human-readable documentation
├── instructions/  # AI instruction sheets
│   ├── ja/        # Japanese instructions
│   │   ├── general/   # General instructions
│   │   ├── coding/    # Coding-related instructions
│   │   ├── writing/   # Writing-related instructions
│   │   ├── analysis/  # Analysis-related instructions
│   │   └── creative/  # Creative-related instructions
│   └── en/        # English instructions
│       ├── general/   # General instructions
│       ├── coding/    # Coding-related instructions
│       ├── writing/   # Writing-related instructions
│       ├── analysis/  # Analysis-related instructions
│       └── creative/  # Creative-related instructions
├── examples/      # Usage examples
│   ├── ja/        # Japanese examples
│   └── en/        # English examples
└── templates/     # Instruction templates
    ├── ja/        # Japanese templates
    └── en/        # English templates
```

## Key Files

### AI Instructions
- **[ROOT_INSTRUCTION_en.md](ROOT_INSTRUCTION_en.md)** - AI operates as instruction manager
- **[INSTRUCTION_SELECTOR_en.md](INSTRUCTION_SELECTOR_en.md)** - Keyword-based automatic selection

### Human Documentation
- **[docs/HOW_TO_USE_en.md](docs/HOW_TO_USE_en.md)** - Detailed usage guide (for humans)
- **[USAGE_GUIDE.md](USAGE_GUIDE.md)** - Usage overview

## Usage

### Basic Usage

1. **Using a single instruction**
   ```bash
   # Specify file path directly
   claude "Refer to instructions/en/coding/basic_code_generation.md and..."
   ```

2. **Using automatic selection**
   ```bash
   # Make AI operate as instruction manager
   claude "Refer to ROOT_INSTRUCTION_en.md and analyze sales data to create a report"
   
   # Keyword-based automatic selection
   claude "Refer to INSTRUCTION_SELECTOR_en.md and implement a Web API"
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